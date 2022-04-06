-- Q8
create type TermTranscriptRecord as (
        term  		char(4), -- term code (e.g. 98s1)
        termwam  	integer, -- numeric term WAM acheived
        termuocpassed   integer  -- units of credit passed this term
);

create or replace function
	Q8(zid integer) returns setof TermTranscriptRecord
as $$
--... SQL statements, possibly using other views/functions defined by you ...
declare
	tuple record;
	final TermTranscriptRecord;

	previous_term char(4) := '';
	
	_termwam integer := 0;
	mu_sum integer := 0;
	overall_mu integer := 0;

	_termuocpassed integer := 0;
	uoc_sum integer := 0;
	wam_uoc integer := 0;
	overall_uoc integer := 0;
begin
	-- Loop through each row in the table
	for tuple in
		select *
		from termtranscipt_table_1
		where unswid = $1
		order by termname asc
	loop
		-- For the first case since previous_term is NULL
		if (previous_term = '') then
			previous_term := tuple.termname;
		end if;
		
		-- Update term wam
		if(tuple.termname = previous_term and tuple.mark is not null) then
			mu_sum := mu_sum + tuple.mark * tuple.uoc;
			overall_mu := overall_mu + tuple.mark * tuple.uoc;
			
			uoc_sum := uoc_sum + tuple.uoc;
			wam_uoc := wam_uoc + tuple.uoc;

			-- Update termuocpassed
			if(tuple.grade = 'SY' or 
				tuple.grade = 'PT' or
				tuple.grade = 'PC' or
				tuple.grade = 'PS' or
				tuple.grade = 'CR' or
				tuple.grade = 'DN' or
				tuple.grade = 'HD' or
				tuple.grade = 'A' or
				tuple.grade = 'B' or
				tuple.grade = 'C' or
				tuple.grade = 'XE' or
				tuple.grade = 'T' or
				tuple.grade = 'PE' or
				tuple.grade = 'RC' or
				tuple.grade = 'RS'
			) then
				_termuocpassed := _termuocpassed + tuple.uoc;
				overall_uoc := overall_uoc + tuple.uoc;
			end if;

		-- If course mark is NULL then continue to next iteration
		elsif(tuple.termname = previous_term and tuple.mark is null) then
			
			-- Update termuocpassed
			if(tuple.grade = 'SY' or 
				tuple.grade = 'PT' or
				tuple.grade = 'PC' or
				tuple.grade = 'PS' or
				tuple.grade = 'CR' or
				tuple.grade = 'DN' or
				tuple.grade = 'HD' or
				tuple.grade = 'A' or
				tuple.grade = 'B' or
				tuple.grade = 'C' or
				tuple.grade = 'XE' or
				tuple.grade = 'T' or
				tuple.grade = 'PE' or
				tuple.grade = 'RC' or
				tuple.grade = 'RS'
			) then
				_termuocpassed := _termuocpassed + tuple.uoc;
				overall_uoc := overall_uoc + tuple.uoc;
			end if;

			continue;

		-- If we have a new term, store data and continue
		else
			final.term = previous_term;
			
			if(mu_sum = 0 or uoc_sum = 0) then
				final.termwam = NULL;
			else
				final.termwam = ROUND(mu_sum::NUMERIC / uoc_sum::NUMERIC);
			end if;
			
			final.termuocpassed = _termuocpassed;
			if(final.termuocpassed = 0) then
				final.termuocpassed = NULL;
			end if;

			return next final;

			-- Re-initialise variables
			previous_term = tuple.termname;
			mu_sum = 0;
			uoc_sum = 0;
			_termuocpassed = 0;

			-- Repeat update on termwam and termuocpassed
			if(tuple.termname = previous_term and tuple.mark is not null) then
				mu_sum := mu_sum + tuple.mark * tuple.uoc;
				overall_mu := overall_mu + tuple.mark * tuple.uoc;
			
				uoc_sum := uoc_sum + tuple.uoc;
				wam_uoc := wam_uoc + tuple.uoc;

				-- Update termuocpassed
				if(tuple.grade = 'SY' or 
					tuple.grade = 'PT' or
					tuple.grade = 'PC' or
					tuple.grade = 'PS' or
					tuple.grade = 'CR' or
					tuple.grade = 'DN' or
					tuple.grade = 'HD' or
					tuple.grade = 'A' or
					tuple.grade = 'B' or
					tuple.grade = 'C' or
					tuple.grade = 'XE' or
					tuple.grade = 'T' or
					tuple.grade = 'PE' or
					tuple.grade = 'RC' or
					tuple.grade = 'RS'
				) then
					_termuocpassed := _termuocpassed + tuple.uoc;
					overall_uoc := overall_uoc + tuple.uoc;
				end if;

			elsif(tuple.termname = previous_term and tuple.mark is NULL) then
				-- Update termuocpassed
				if(tuple.grade = 'SY' or 
					tuple.grade = 'PT' or
					tuple.grade = 'PC' or
					tuple.grade = 'PS' or
					tuple.grade = 'CR' or
					tuple.grade = 'DN' or
					tuple.grade = 'HD' or
					tuple.grade = 'A' or
					tuple.grade = 'B' or
					tuple.grade = 'C' or
					tuple.grade = 'XE' or
					tuple.grade = 'T' or
					tuple.grade = 'PE' or
					tuple.grade = 'RC' or
					tuple.grade = 'RS'
				) then
					_termuocpassed := _termuocpassed + tuple.uoc;
					overall_uoc := overall_uoc + tuple.uoc;
				end if;

				continue;

			end if;

		end if;

	end loop;
		-- If student zid is invalid, return empty table
		if(not found) then
			return;
		end if;

		-- Last row of table being updated
		final.term = previous_term;
		
		if(mu_sum = 0 and uoc_sum = 0) then
			final.termwam = NULL;
		else
			final.termwam = ROUND(mu_sum::NUMERIC / uoc_sum::NUMERIC);
		end if;
		
		final.termuocpassed = _termuocpassed;
		if(final.termuocpassed = 0) then
			final.termuocpassed = NULL;
		end if;

		return next final;

		-- Add final row for OVAL
		final.term = 'OVAL';

		if(wam_uoc = 0) then
			final.termwam = NULL;
		else
			final.termwam = ROUND(overall_mu::NUMERIC / wam_uoc::NUMERIC);
		end if;

		final.termuocpassed = overall_uoc;
		return next final;
		
end

$$ language plpgsql;