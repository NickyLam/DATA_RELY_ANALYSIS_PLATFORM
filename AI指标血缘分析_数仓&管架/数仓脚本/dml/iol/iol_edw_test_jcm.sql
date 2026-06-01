truncate table iol.edw_test_jcm;

insert into edw_test_jcm(
     etl_dt,
     execdate
) 
select 
    etl_dt,
    execdate 
from itl.edw_test_jcm;
commit;
