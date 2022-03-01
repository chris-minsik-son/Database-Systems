-- Week 2 Exercise from Lecture Slides

create table Projects (
    projNo integer,
    title text not null,
    budget integer,
    primary key (projNo)
);



create table Department (
    name text,
    location text,
    phone text,
    -- We will update this later as this will cause error
    -- manager integer not null references Employees(ssn),
    primary key (name)
);

create table Employees (
    ssn integer,
    name text not null,
    dob date,
    -- Every employee is in a department
    WorksIn text not null references Department(name),
    primary key (ssn)
);

-- Updating Department table
alter table Department add manager integer not null references Employees(ssn);



create table WeakEntity (
    name text,
    relationship text,
    phone text,
    emp integer,
    foreign key (empSSN) references Employees(ssn),
    primary key(name, emp)
);

create table WorksOn (
    emp integer,
    proj integer,
    primary key (emp, proj),
    foreign key (emp) references Employees(ssn),
    foreign key (proj) references Projects(projNo)
);
