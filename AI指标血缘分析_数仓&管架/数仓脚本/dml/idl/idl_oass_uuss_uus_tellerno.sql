/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_uuss_uus_tellerno
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_uuss_uus_tellerno drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_uuss_uus_tellerno add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_uuss_uus_tellerno (
etl_dt  --数据日期
,attachorgan  --柜员所属机构
,tellerno  --柜员号
,tellerlevel  --柜员级别
,organcode  --所在部门编号
,status  --柜员状态：0-正常，1-注销
,userna  --柜员名称
,ussatg  --平账状态
,lastlg  --最后登录日期
,lstrdt  --最后交易日期
,usertp  --柜员类型
,menugp  --超级柜员标志
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,employeeid  --员工编号
,tellermanagerid  --柜员主管编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.attachorgan,chr(13),''),chr(10),'') as attachorgan --柜员所属机构
,replace(replace(t1.tellerno,chr(13),''),chr(10),'') as tellerno --柜员号
,replace(replace(t1.tellerlevel,chr(13),''),chr(10),'') as tellerlevel --柜员级别
,replace(replace(t1.organcode,chr(13),''),chr(10),'') as organcode --所在部门编号
,replace(replace(t1.status,chr(13),''),chr(10),'') as status --柜员状态：0-正常，1-注销
,replace(replace(t1.userna,chr(13),''),chr(10),'') as userna --柜员名称
,replace(replace(t1.ussatg,chr(13),''),chr(10),'') as ussatg --平账状态
,replace(replace(t1.lastlg,chr(13),''),chr(10),'') as lastlg --最后登录日期
,replace(replace(t1.lstrdt,chr(13),''),chr(10),'') as lstrdt --最后交易日期
,replace(replace(t1.usertp,chr(13),''),chr(10),'') as usertp --柜员类型
,replace(replace(t1.menugp,chr(13),''),chr(10),'') as menugp --超级柜员标志
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.employeeid,chr(13),''),chr(10),'') as employeeid --员工编号
,replace(replace(t1.tellermanagerid,chr(13),''),chr(10),'') as tellermanagerid --柜员主管编号
from ${iol_schema}.uuss_uus_tellerno t1    --柜员信息表
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_uuss_uus_tellerno',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
