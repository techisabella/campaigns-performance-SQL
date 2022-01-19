#Draft few core tables and relationships between them ✓ 
#Tables in your DB need to be normalised ✓ 

CREATE database campaigns_performance;
USE campaigns_performance;

#Create relational DB of your choice with minimum 5 tables ✓ 
#Set Primary and Foreign Key constraints to create relations between the tables ✓ 

CREATE TABLE business_unit
(id int not null primary key auto_increment,
name varchar (20) not null,
location varchar(20)
);


CREATE TABLE channels
(id int not null primary key AUTO_INCREMENT,
name varchar (20) not null
);

CREATE TABLE marketing_campaigns
(id int not null AUTO_INCREMENT,
name varchar (20) not null,
start_date date not null,
end_date date not null,
business_unit_id int not null,
channel_id int not null,
budget int not null,
primary key (id),
CONSTRAINT FK_business_unit_id
foreign key (business_unit_id)
references business_unit (id),
CONSTRAINT FK_channel_id
foreign key (channel_id)
references channels (id)
);


CREATE TABLE metrics
(id int not null AUTO_INCREMENT,
clicks int not null,
revenue int not null,
impressions int not null,
CTR float(2) not null,
campaign_id int not null,
primary key (id),
CONSTRAINT FK_campaign_id
FOREIGN KEY (campaign_id)
REFERENCES marketing_campaigns (id)
);


CREATE TABLE employees
(id int not null primary key AUTO_INCREMENT,
name varchar (20) not null,
surname varchar (20) not null
);

CREATE TABLE campaign_employees
(campaign_id int not null,
employee_id int not null,
primary key (campaign_id, employee_id),
constraint fk_campaignid
foreign key (campaign_id) references marketing_campaigns (id),
constraint fk_employeeid
foreign key (employee_id) references employees (id)
);

INSERT INTO business_unit
(name, location)
VALUES
('investments',  'Glasgow '),
('mortgages',  'Liverpool '),
('credit_cards',  'London '),
('savings',  'Birmigham '),
('insurance',  'Cardiff ');


INSERT INTO channels
(name)
VALUES
('ppc'),
('seo'),
('email'),
('pr');


INSERT INTO marketing_campaigns
(name, start_date, end_date, business_unit_id, channel_id, budget)
VALUES
('tax_year_end', '2020-01-11', '2021-01-04', (SELECT ID FROM BUSINESS_UNIT WHERE NAME = 'INVESTMENTS'),(SELECT ID FROM CHANNELS WHERE NAME = 'PPC'), 30000000),
('stamp_duty', '2020-11-02', '2021-02-04', (SELECT ID FROM BUSINESS_UNIT WHERE NAME = 'insurance'),(SELECT ID FROM CHANNELS WHERE NAME = 'SEO'), 29980000),
('help_to_buy', '2020-11-03', '2021-02-04', (SELECT ID FROM BUSINESS_UNIT WHERE NAME = 'mortgages'),(SELECT ID FROM CHANNELS WHERE NAME = 'EMAIL'), 29930000),
('brexit', '2020-11-04', '2021-03-04', (SELECT ID FROM BUSINESS_UNIT WHERE NAME = 'savings'), (SELECT ID FROM CHANNELS WHERE NAME = 'PR'), 29880000),
('Black_Friday', '2020-11-05', '2021-04-04', (SELECT ID FROM BUSINESS_UNIT WHERE NAME = 'INVESTMENTS'), (SELECT ID FROM CHANNELS WHERE NAME = 'PPC'), 29830000);


INSERT INTO metrics
(clicks, revenue, impressions, ctr, campaign_id)
VALUES
(100000, 239840284, 3000000, 3.33, (SELECT ID FROM MARKETING_CAMPAIGNS WHERE NAME = 'tax_year_end')),
(50000, 59960071, 1000000, 5.00, (SELECT ID FROM MARKETING_CAMPAIGNS WHERE NAME = 'stamp_duty')),
(25000, 59950071, 333333, 7.50, (SELECT ID FROM MARKETING_CAMPAIGNS WHERE NAME = 'help_to_buy')),
(12500, 59940071, 111111, 11.25, (SELECT ID FROM MARKETING_CAMPAIGNS WHERE NAME = 'brexit')),
(6250, 59930071, 37037, 16.88, (SELECT ID FROM MARKETING_CAMPAIGNS WHERE NAME = 'black_friday'));


INSERT INTO employees
(name, surname)
VALUES
('Rogelio', 'de La Vega'),
('Plutarco', 'Jones'),
('Sarah', 'Webster'),
('Amalia', 'Navarro'),
('Hammad', 'Schneider');


INSERT INTO campaign_employees
(campaign_id, employee_id)
VALUES
((SELECT ID FROM MARKETING_CAMPAIGNS WHERE NAME = 'tax_year_end'), (SELECT ID FROM EMPLOYEES WHERE NAME = 'Rogelio')),
((SELECT ID FROM MARKETING_CAMPAIGNS WHERE NAME = 'stamp_duty'), (SELECT ID FROM EMPLOYEES WHERE NAME = 'Plutarco')),
((SELECT ID FROM MARKETING_CAMPAIGNS WHERE NAME = 'help_to_buy'), (SELECT ID FROM EMPLOYEES WHERE NAME = 'Sarah')),
((SELECT ID FROM MARKETING_CAMPAIGNS WHERE NAME = 'brexit'), (SELECT ID FROM EMPLOYEES WHERE NAME = 'Amalia')),
((SELECT ID FROM MARKETING_CAMPAIGNS WHERE NAME = 'black_friday'), (SELECT ID FROM EMPLOYEES WHERE NAME = 'Hammad'));


#Using any type of the joins create a view that combines multiple tables in a logical way ✓ 
#Top 3 campaigns based on revenue and traffic
SELECT mc.name, m.revenue, m.clicks
FROM marketing_campaigns mc
INNER JOIN
Metrics m
ON m.campaign_id = mc.id
ORDER BY m.revenue DESC
LIMIT 3;


#Prepare an example query with a subquery to demonstrate how to extract data from your DB for analysis ✓
#Show all the marketing campaigns that have email and ppc as channel
SELECT mc.name, channels.name
FROM marketing_campaigns mc
INNER JOIN channels 
ON mc.channel_id = channels.id
WHERE mc.channel_id IN (
	SELECT id FROM channels
    WHERE name = 'email' or name = 'ppc');
    
#Show all the marketing campaigns that had been run by the savings or investments business units
SELECT mc.name, mc.business_unit_id
FROM marketing_campaigns mc
WHERE mc.business_unit_id IN (
	SELECT id FROM business_unit
    WHERE name = 'savings' or name = 'investments');

#Create DB diagram where all table relations are shown ✓

#ADVANCED OPTIONS
#Create a view that uses at least 3 4 base tables; prepare and demonstrate
#a query that uses the view to produce a logically arranged result set for analysis  ✓ 


#Create a simplified view for Tableau to show to the analytics colleagues who will build the dashboard 
#performing campaigns in terms of CTR with the purpose of rewarding the best performing BU 

CREATE VIEW tableau_campaign_reporting
AS
SELECT mc.name as campaign_name, mc.budget as campaign_budget, m.ctr as campaign_CTR, bu.name as business_unit
FROM marketing_campaigns AS mc
INNER JOIN metrics m
ON mc.id = m.campaign_id
inner join business_unit bu
ON mc.business_unit_id = bu.id
ORDER BY campaign_ctr DESC;

select * from tableau_campaign_reporting


#Prepare an example query with group by and having to demonstrate how to extract data from your DB for analysis  ✓

SELECT bu.location, sum(m.impressions) as total_impressions
FROM marketing_campaigns mc
JOIN business_unit bu
ON mc.business_unit_id = bu.id
JOIN metrics m
ON m.campaign_id = mc.id
GROUP BY bu.location
ORDER BY total_impressions DESC
LIMIT 3;


#The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions.

SELECT bu.location, sum(m.impressions) as total_impressions
FROM marketing_campaigns mc
JOIN business_unit bu
ON mc.business_unit_id = bu.id
JOIN metrics m
ON m.campaign_id = mc.id
GROUP BY bu.location
HAVING sum(m.impressions) >  333334
ORDER BY total_impressions DESC
LIMIT 3;
