## Scripts for MySQL usage

### Usage

```bash
bash setup/MySQL/convert_mysql.sh <username> <password> <db_name>
```

If db_name is missing it will use default database name: atpdatabase

### Example
Which grand slam sees the most five setters?
```sql
select tourney_name,count(tourney_name) from matches where score ilike '%-%-%-%-%-%' and tourney_level='G' group by tourney_name order by count(tourney_name);
```
      tourney_name   | count
    -----------------+-------
     Australian Open |   877
     US Open         |  1006
     Roland Garros   |  1025
     Wimbledon       |  1170
    (4 rows)
