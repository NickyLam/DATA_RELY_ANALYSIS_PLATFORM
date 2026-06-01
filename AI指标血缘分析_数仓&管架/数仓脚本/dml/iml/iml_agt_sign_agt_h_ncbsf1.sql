/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_sign_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_sign_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_sign_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_sign_agt_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_sign_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_sign_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_sign_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_sign_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rels_revo_dt -- 解约撤销日期
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,rels_dt -- 解约日期
    ,sign_dt -- 签约日期
    ,acct_curr_cd -- 账户币种代码
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,bxt_sign_status_cd -- 北向通签约状态代码
    ,rels_appl_dt -- 解约申请日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_sign_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_sign_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_sign_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_sign_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_sign_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_agreement_northbound-1
insert into ${iml_schema}.agt_sign_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rels_revo_dt -- 解约撤销日期
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,rels_dt -- 解约日期
    ,sign_dt -- 签约日期
    ,acct_curr_cd -- 账户币种代码
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,bxt_sign_status_cd -- 北向通签约状态代码
    ,rels_appl_dt -- 解约申请日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300003'||P1.AGREEMENT_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.UNSIGNAPPLYREVERTDATE -- 解约撤销日期
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.AGREEMENT_TYPE -- 签约协议类型代码
    ,P1.OUT_SIGN_DATE -- 解约日期
    ,P1.SIGN_DATE -- 签约日期
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.OUT_SIGN_BRANCH -- 解约机构编号
    ,P1.OUT_SIGN_USER_ID -- 解约柜员编号
    ,P1.SIGN_BRANCH -- 签约机构编号
    ,P1.SIGN_USER_ID -- 签约柜员编号
    ,P1.NORTHBOUND_STATUS -- 北向通签约状态代码
    ,P1.UNSIGNAPPLAYDATE -- 解约申请日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_agreement_northbound' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_northbound p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_sign_agt_h_ncbsf1_tm 
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
        into ${iml_schema}.agt_sign_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rels_revo_dt -- 解约撤销日期
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,rels_dt -- 解约日期
    ,sign_dt -- 签约日期
    ,acct_curr_cd -- 账户币种代码
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,bxt_sign_status_cd -- 北向通签约状态代码
    ,rels_appl_dt -- 解约申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_sign_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rels_revo_dt -- 解约撤销日期
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,rels_dt -- 解约日期
    ,sign_dt -- 签约日期
    ,acct_curr_cd -- 账户币种代码
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,bxt_sign_status_cd -- 北向通签约状态代码
    ,rels_appl_dt -- 解约申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.rels_revo_dt, o.rels_revo_dt) as rels_revo_dt -- 解约撤销日期
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.sign_agt_type_cd, o.sign_agt_type_cd) as sign_agt_type_cd -- 签约协议类型代码
    ,nvl(n.rels_dt, o.rels_dt) as rels_dt -- 解约日期
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.acct_curr_cd, o.acct_curr_cd) as acct_curr_cd -- 账户币种代码
    ,nvl(n.rels_org_id, o.rels_org_id) as rels_org_id -- 解约机构编号
    ,nvl(n.rels_teller_id, o.rels_teller_id) as rels_teller_id -- 解约柜员编号
    ,nvl(n.sign_org_id, o.sign_org_id) as sign_org_id -- 签约机构编号
    ,nvl(n.sign_teller_id, o.sign_teller_id) as sign_teller_id -- 签约柜员编号
    ,nvl(n.bxt_sign_status_cd, o.bxt_sign_status_cd) as bxt_sign_status_cd -- 北向通签约状态代码
    ,nvl(n.rels_appl_dt, o.rels_appl_dt) as rels_appl_dt -- 解约申请日期
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
from ${iml_schema}.agt_sign_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_sign_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
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
        o.rels_revo_dt <> n.rels_revo_dt
        or o.sub_acct_num <> n.sub_acct_num
        or o.cust_acct_num <> n.cust_acct_num
        or o.cust_id <> n.cust_id
        or o.prod_id <> n.prod_id
        or o.sign_agt_type_cd <> n.sign_agt_type_cd
        or o.rels_dt <> n.rels_dt
        or o.sign_dt <> n.sign_dt
        or o.acct_curr_cd <> n.acct_curr_cd
        or o.rels_org_id <> n.rels_org_id
        or o.rels_teller_id <> n.rels_teller_id
        or o.sign_org_id <> n.sign_org_id
        or o.sign_teller_id <> n.sign_teller_id
        or o.bxt_sign_status_cd <> n.bxt_sign_status_cd
        or o.rels_appl_dt <> n.rels_appl_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_sign_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rels_revo_dt -- 解约撤销日期
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,rels_dt -- 解约日期
    ,sign_dt -- 签约日期
    ,acct_curr_cd -- 账户币种代码
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,bxt_sign_status_cd -- 北向通签约状态代码
    ,rels_appl_dt -- 解约申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_sign_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,rels_revo_dt -- 解约撤销日期
    ,sub_acct_num -- 子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,sign_agt_type_cd -- 签约协议类型代码
    ,rels_dt -- 解约日期
    ,sign_dt -- 签约日期
    ,acct_curr_cd -- 账户币种代码
    ,rels_org_id -- 解约机构编号
    ,rels_teller_id -- 解约柜员编号
    ,sign_org_id -- 签约机构编号
    ,sign_teller_id -- 签约柜员编号
    ,bxt_sign_status_cd -- 北向通签约状态代码
    ,rels_appl_dt -- 解约申请日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.rels_revo_dt -- 解约撤销日期
    ,o.sub_acct_num -- 子账号
    ,o.cust_acct_num -- 客户账号
    ,o.cust_id -- 客户编号
    ,o.prod_id -- 产品编号
    ,o.sign_agt_type_cd -- 签约协议类型代码
    ,o.rels_dt -- 解约日期
    ,o.sign_dt -- 签约日期
    ,o.acct_curr_cd -- 账户币种代码
    ,o.rels_org_id -- 解约机构编号
    ,o.rels_teller_id -- 解约柜员编号
    ,o.sign_org_id -- 签约机构编号
    ,o.sign_teller_id -- 签约柜员编号
    ,o.bxt_sign_status_cd -- 北向通签约状态代码
    ,o.rels_appl_dt -- 解约申请日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_sign_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_sign_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_sign_agt_h_ncbsf1_cl d
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
--truncate table ${iml_schema}.agt_sign_agt_h;
alter table ${iml_schema}.agt_sign_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_sign_agt_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_sign_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_sign_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_sign_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_sign_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_sign_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_sign_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_sign_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_sign_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_sign_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
