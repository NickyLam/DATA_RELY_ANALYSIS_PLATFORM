/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_rg_cd_para_eifsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_rg_cd_para_eifsf1_tm purge;
drop table ${iml_schema}.ref_rg_cd_para_eifsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_rg_cd_para add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_rg_cd_para modify partition p_eifsf1
    add subpartition p_eifsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_rg_cd_para_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_rg_cd_para partition for ('eifsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_rg_cd_para_eifsf1_tm
compress ${option_switch} for query high
as
select
    rg_cd -- 地区代码
    ,rg_cd_type -- 地区代码类型
    ,prov -- 省
    ,city -- 市
    ,county -- 县
    ,addr -- 地址
    ,rela_rg_cd_1 -- 关联地区代码1
    ,rela_rg_cd_type_1 -- 关联地区代码类型1
    ,rela_rg_cd_2 -- 关联地区代码2
    ,rela_rg_cd_type_2 -- 关联地区代码类型2
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_rg_cd_para
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_rg_cd_para_eifsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_rg_cd_para partition for ('eifsf1') where 0=1;

-- 2.1 insert data to tm table
-- eifs_issued_area_code-area_code
insert into ${iml_schema}.ref_rg_cd_para_eifsf1_tm(
    rg_cd -- 地区代码
    ,rg_cd_type -- 地区代码类型
    ,prov -- 省
    ,city -- 市
    ,county -- 县
    ,addr -- 地址
    ,rela_rg_cd_1 -- 关联地区代码1
    ,rela_rg_cd_type_1 -- 关联地区代码类型1
    ,rela_rg_cd_2 -- 关联地区代码2
    ,rela_rg_cd_type_2 -- 关联地区代码类型2
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.AREA_CODE -- 地区代码
    ,'4位地区代码' -- 地区代码类型
    ,P1.STATE_PROVINCE_GEO_ID -- 省
    ,P1.CITY -- 市
    ,P1.COUNTY -- 县
    ,P1.ADDRESS -- 地址
    ,P1.AREA_CODE2 -- 关联地区代码1
    ,'6位地区代码' -- 关联地区代码类型1
    ,P1.AREA_CODE3 -- 关联地区代码2
    ,'人行地区代码' -- 关联地区代码类型2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_issued_area_code' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_issued_area_code p1
    inner join (select a.*, row_number() over(partition by area_code order by area_code2) seq 
from ${iol_schema}.eifs_issued_area_code a 
where a.area_code<>' '  
and a.start_dt<= to_date('${batch_date}','yyyymmdd') 
and a.end_dt > to_date('${batch_date}','yyyymmdd'))  p2 on p1.area_code=p2.area_code and p1.area_code2=p2.area_code2 and p2.seq=1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


insert into ${iml_schema}.ref_rg_cd_para_eifsf1_tm(
    rg_cd -- 地区代码
    ,rg_cd_type -- 地区代码类型
    ,prov -- 省
    ,city -- 市
    ,county -- 县
    ,addr -- 地址
    ,rela_rg_cd_1 -- 关联地区代码1
    ,rela_rg_cd_type_1 -- 关联地区代码类型1
    ,rela_rg_cd_2 -- 关联地区代码2
    ,rela_rg_cd_type_2 -- 关联地区代码类型2
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.AREA_CODE2 -- 地区代码
    ,'6位地区代码' -- 地区代码类型
    ,P1.STATE_PROVINCE_GEO_ID -- 省
    ,P1.CITY -- 市
    ,P1.COUNTY -- 县
    ,P1.ADDRESS -- 地址
    ,P1.AREA_CODE -- 关联地区代码1
    ,'4位地区代码' -- 关联地区代码类型1
    ,P1.AREA_CODE3 -- 关联地区代码2
    ,'人行地区代码' -- 关联地区代码类型2
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_issued_area_code' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_issued_area_code p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and trim(p1.area_code2) is not null and trim(p1.area_code2)<>'无'
;
commit;
commit;


-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ref_rg_cd_para_eifsf1_ex(
    rg_cd -- 地区代码
    ,rg_cd_type -- 地区代码类型
    ,prov -- 省
    ,city -- 市
    ,county -- 县
    ,addr -- 地址
    ,rela_rg_cd_1 -- 关联地区代码1
    ,rela_rg_cd_type_1 -- 关联地区代码类型1
    ,rela_rg_cd_2 -- 关联地区代码2
    ,rela_rg_cd_type_2 -- 关联地区代码类型2
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.rg_cd, o.rg_cd) as rg_cd -- 地区代码
    ,nvl(n.rg_cd_type, o.rg_cd_type) as rg_cd_type -- 地区代码类型
    ,nvl(n.prov, o.prov) as prov -- 省
    ,nvl(n.city, o.city) as city -- 市
    ,nvl(n.county, o.county) as county -- 县
    ,nvl(n.addr, o.addr) as addr -- 地址
    ,nvl(n.rela_rg_cd_1, o.rela_rg_cd_1) as rela_rg_cd_1 -- 关联地区代码1
    ,nvl(n.rela_rg_cd_type_1, o.rela_rg_cd_type_1) as rela_rg_cd_type_1 -- 关联地区代码类型1
    ,nvl(n.rela_rg_cd_2, o.rela_rg_cd_2) as rela_rg_cd_2 -- 关联地区代码2
    ,nvl(n.rela_rg_cd_type_2, o.rela_rg_cd_type_2) as rela_rg_cd_type_2 -- 关联地区代码类型2
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.rg_cd is null
            ) or (
                o.rg_cd_type <> n.rg_cd_type
                or o.prov <> n.prov
                or o.city <> n.city
                or o.county <> n.county
                or o.addr <> n.addr
                or o.rela_rg_cd_1 <> n.rela_rg_cd_1
                or o.rela_rg_cd_type_1 <> n.rela_rg_cd_type_1
                or o.rela_rg_cd_2 <> n.rela_rg_cd_2
                or o.rela_rg_cd_type_2 <> n.rela_rg_cd_type_2
            ) or (
                 case when (
                           n.rg_cd is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.rg_cd is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_rg_cd_para_eifsf1_tm n
    full join ${iml_schema}.ref_rg_cd_para_eifsf1_bk o
        on
            o.rg_cd = n.rg_cd
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_rg_cd_para truncate partition for ('eifsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_rg_cd_para exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.ref_rg_cd_para_eifsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_rg_cd_para drop subpartition p_eifsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_rg_cd_para to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_rg_cd_para_eifsf1_tm purge;
drop table ${iml_schema}.ref_rg_cd_para_eifsf1_ex purge;
drop table ${iml_schema}.ref_rg_cd_para_eifsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_rg_cd_para', partname => 'p_eifsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);