/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_finc_acct_ifmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_finc_acct add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ifmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_finc_acct_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_acct partition for ('ifmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_finc_acct_ifmsf1_tm purge;
drop table ${iml_schema}.agt_finc_acct_ifmsf1_op purge;
drop table ${iml_schema}.agt_finc_acct_ifmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_acct_ifmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,intnal_cust_acct -- 内部客户账户
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_way_cd -- 开户方式代码
    ,cust_type_cd -- 客户类型代码
    ,bus_cate_cd -- 业务类别代码
    ,acct_status_cd -- 账户状态代码
    ,open_dt -- 开通日期
    ,sign_acct_id -- 签约账户编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_acct partition for ('ifmsf1')
where 0=1
;

create table ${iml_schema}.agt_finc_acct_ifmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_acct partition for ('ifmsf1') where 0=1;

create table ${iml_schema}.agt_finc_acct_ifmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_acct partition for ('ifmsf1') where 0=1;

-- 3.1 get new data into table
-- ifms_tbassetacc-
insert into ${iml_schema}.agt_finc_acct_ifmsf1_tm(
    agt_id -- 协议编号
    ,intnal_cust_acct -- 内部客户账户
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_way_cd -- 开户方式代码
    ,cust_type_cd -- 客户类型代码
    ,bus_cate_cd -- 业务类别代码
    ,acct_status_cd -- 账户状态代码
    ,open_dt -- 开通日期
    ,sign_acct_id -- 签约账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160010'||P1.IN_CLIENT_NO||P1.TA_CODE -- 协议编号
    ,P1.IN_CLIENT_NO -- 内部客户账户
    ,'9999' -- 法人编号
    ,P1.TA_CODE -- TA代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,P1.OPEN_FLAG -- 开户方式代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PRD_TYPE END -- 业务类别代码
    ,P1.STATUS -- 账户状态代码
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.OPEN_DATE)) -- 开通日期
    ,P1.RESERVE2 -- 签约账户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbassetacc' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbassetacc p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBASSETACC'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FINC_ACCT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PRD_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_TBASSETACC'
        AND R2.SRC_FIELD_EN_NAME= 'PRD_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_FINC_ACCT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BUS_CATE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ifms_tbhisassetacc-
insert into ${iml_schema}.agt_finc_acct_ifmsf1_tm(
    agt_id -- 协议编号
    ,intnal_cust_acct -- 内部客户账户
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_way_cd -- 开户方式代码
    ,cust_type_cd -- 客户类型代码
    ,bus_cate_cd -- 业务类别代码
    ,acct_status_cd -- 账户状态代码
    ,open_dt -- 开通日期
    ,sign_acct_id -- 签约账户编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160010'||P1.IN_CLIENT_NO||P1.TA_CODE -- 协议编号
    ,P1.IN_CLIENT_NO -- 内部客户账户
    ,'9999' -- 法人编号
    ,P1.TA_CODE -- TA代码
    ,P1.ASSET_ACC -- 理财账户编号
    ,P1.OPEN_BRANCH -- 所属机构编号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.CLIENT_MANAGER -- 客户经理编号
    ,P1.OPEN_FLAG -- 开户方式代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.PRD_TYPE END -- 业务类别代码
    ,P1.STATUS -- 账户状态代码
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.OPEN_DATE)) -- 开通日期
    ,P1.RESERVE2 -- 签约账户编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbhisassetacc' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbhisassetacc p1
    left join ${iol_schema}.ifms_tbassetacc p2 on P1.IN_CLIENT_NO = P2.IN_CLIENT_NO
AND P1.TA_CODE = P2.TA_CODE
AND P2.START_dt <= to_date('${batch_date}','yyyymmdd') 
AND P2.END_DT > to_date('${batch_date}','yyyymmdd') 
    inner join (select in_client_no,ta_code,max(close_date) as close_date
   from ${iol_schema}.ifms_tbhisassetacc 
where 1=1
and start_dt <= to_date('${batch_date}','yyyymmdd') 
and end_dt > to_date('${batch_date}','yyyymmdd') 
group by in_client_no,ta_code
) p3 on P1.IN_CLIENT_NO = P3.IN_CLIENT_NO
AND P1.TA_CODE = P3.TA_CODE
AND P1.close_date = P3.close_date
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBASSETACC'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_FINC_ACCT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.PRD_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'IFMS'
        AND R2.SRC_TAB_EN_NAME= 'IFMS_TBASSETACC'
        AND R2.SRC_FIELD_EN_NAME= 'PRD_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_FINC_ACCT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BUS_CATE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND P2.IN_CLIENT_NO IS NULL 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_finc_acct_ifmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_finc_acct_ifmsf1_cl(
            agt_id -- 协议编号
    ,intnal_cust_acct -- 内部客户账户
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_way_cd -- 开户方式代码
    ,cust_type_cd -- 客户类型代码
    ,bus_cate_cd -- 业务类别代码
    ,acct_status_cd -- 账户状态代码
    ,open_dt -- 开通日期
    ,sign_acct_id -- 签约账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_acct_ifmsf1_op(
            agt_id -- 协议编号
    ,intnal_cust_acct -- 内部客户账户
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_way_cd -- 开户方式代码
    ,cust_type_cd -- 客户类型代码
    ,bus_cate_cd -- 业务类别代码
    ,acct_status_cd -- 账户状态代码
    ,open_dt -- 开通日期
    ,sign_acct_id -- 签约账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.intnal_cust_acct, o.intnal_cust_acct) as intnal_cust_acct -- 内部客户账户
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.ta_cd, o.ta_cd) as ta_cd -- TA代码
    ,nvl(n.finc_acct_id, o.finc_acct_id) as finc_acct_id -- 理财账户编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.ta_tran_acct_id, o.ta_tran_acct_id) as ta_tran_acct_id -- TA交易账户编号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.open_acct_way_cd, o.open_acct_way_cd) as open_acct_way_cd -- 开户方式代码
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.bus_cate_cd, o.bus_cate_cd) as bus_cate_cd -- 业务类别代码
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.open_dt, o.open_dt) as open_dt -- 开通日期
    ,nvl(n.sign_acct_id, o.sign_acct_id) as sign_acct_id -- 签约账户编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_acct_ifmsf1_tm n
    full join (select * from ${iml_schema}.agt_finc_acct_ifmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.intnal_cust_acct <> n.intnal_cust_acct
        or o.ta_cd <> n.ta_cd
        or o.finc_acct_id <> n.finc_acct_id
        or o.belong_org_id <> n.belong_org_id
        or o.ta_tran_acct_id <> n.ta_tran_acct_id
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.open_acct_way_cd <> n.open_acct_way_cd
        or o.cust_type_cd <> n.cust_type_cd
        or o.bus_cate_cd <> n.bus_cate_cd
        or o.acct_status_cd <> n.acct_status_cd
        or o.open_dt <> n.open_dt
        or o.sign_acct_id <> n.sign_acct_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_finc_acct_ifmsf1_cl(
            agt_id -- 协议编号
    ,intnal_cust_acct -- 内部客户账户
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_way_cd -- 开户方式代码
    ,cust_type_cd -- 客户类型代码
    ,bus_cate_cd -- 业务类别代码
    ,acct_status_cd -- 账户状态代码
    ,open_dt -- 开通日期
    ,sign_acct_id -- 签约账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_finc_acct_ifmsf1_op(
            agt_id -- 协议编号
    ,intnal_cust_acct -- 内部客户账户
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,finc_acct_id -- 理财账户编号
    ,belong_org_id -- 所属机构编号
    ,ta_tran_acct_id -- TA交易账户编号
    ,cust_mgr_id -- 客户经理编号
    ,open_acct_way_cd -- 开户方式代码
    ,cust_type_cd -- 客户类型代码
    ,bus_cate_cd -- 业务类别代码
    ,acct_status_cd -- 账户状态代码
    ,open_dt -- 开通日期
    ,sign_acct_id -- 签约账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.intnal_cust_acct -- 内部客户账户
    ,o.lp_id -- 法人编号
    ,o.ta_cd -- TA代码
    ,o.finc_acct_id -- 理财账户编号
    ,o.belong_org_id -- 所属机构编号
    ,o.ta_tran_acct_id -- TA交易账户编号
    ,o.cust_mgr_id -- 客户经理编号
    ,o.open_acct_way_cd -- 开户方式代码
    ,o.cust_type_cd -- 客户类型代码
    ,o.bus_cate_cd -- 业务类别代码
    ,o.acct_status_cd -- 账户状态代码
    ,o.open_dt -- 开通日期
    ,o.sign_acct_id -- 签约账户编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_acct_ifmsf1_bk o
    left join ${iml_schema}.agt_finc_acct_ifmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_finc_acct_ifmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_finc_acct;
--alter table ${iml_schema}.agt_finc_acct truncate partition for ('ifmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_finc_acct') 
               and substr(subpartition_name,1,8)=upper('p_ifmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_finc_acct drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_finc_acct modify partition p_ifmsf1 
add subpartition p_ifmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_finc_acct exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.agt_finc_acct_ifmsf1_cl;
alter table ${iml_schema}.agt_finc_acct exchange subpartition p_ifmsf1_20991231 with table ${iml_schema}.agt_finc_acct_ifmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_finc_acct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_finc_acct_ifmsf1_tm purge;
drop table ${iml_schema}.agt_finc_acct_ifmsf1_op purge;
drop table ${iml_schema}.agt_finc_acct_ifmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_finc_acct_ifmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_finc_acct', partname => 'p_ifmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
