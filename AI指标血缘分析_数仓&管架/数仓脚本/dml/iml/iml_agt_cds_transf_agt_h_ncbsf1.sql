/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cds_transf_agt_h_ncbsf1
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
alter table ${iml_schema}.agt_cds_transf_agt_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_transf_agt_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,init_cust_acct_num -- 原客户账号
    ,init_oc_cd -- 原币种代码
    ,init_sub_acct_num -- 原子账号
    ,init_prod_id -- 原产品编号
    ,init_cust_id -- 原客户编号
    ,init_int_enter_acct_cust_acct_num -- 原利息入账客户账号
    ,init_int_enter_curr_cd -- 原利息入账账户币种代码
    ,init_int_enter_acct_sub_acct_num -- 原利息入账子账号
    ,init_int_enter_prod_id -- 原利息入账账户产品编号
    ,init_acct_name -- 原账户名称
    ,init_int_enter_name -- 原利息入账账户名称
    ,new_int_enter_acct_cust_acct_num -- 新利息入账客户账号
    ,new_int_enter_curr_cd -- 新利息入账账户币种代码
    ,new_int_enter_acct_sub_acct_num -- 新利息入账子账号
    ,new_int_enter_prod_id -- 新利息入账账户产品编号
    ,new_int_enter_name -- 新利息入账账户名称
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,pd_cd -- 期次代码
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,auth_teller_id -- 授权柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_transf_agt_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_transf_agt_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_transf_agt_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_dc_change_info-1
insert into ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,init_cust_acct_num -- 原客户账号
    ,init_oc_cd -- 原币种代码
    ,init_sub_acct_num -- 原子账号
    ,init_prod_id -- 原产品编号
    ,init_cust_id -- 原客户编号
    ,init_int_enter_acct_cust_acct_num -- 原利息入账客户账号
    ,init_int_enter_curr_cd -- 原利息入账账户币种代码
    ,init_int_enter_acct_sub_acct_num -- 原利息入账子账号
    ,init_int_enter_prod_id -- 原利息入账账户产品编号
    ,init_acct_name -- 原账户名称
    ,init_int_enter_name -- 原利息入账账户名称
    ,new_int_enter_acct_cust_acct_num -- 新利息入账客户账号
    ,new_int_enter_curr_cd -- 新利息入账账户币种代码
    ,new_int_enter_acct_sub_acct_num -- 新利息入账子账号
    ,new_int_enter_prod_id -- 新利息入账账户产品编号
    ,new_int_enter_name -- 新利息入账账户名称
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,pd_cd -- 期次代码
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,auth_teller_id -- 授权柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,'9999' -- 法人编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.ACCT_CCY -- 账户币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.ACCT_BRANCH -- 开户机构编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.OLD_BASE_ACCT_NO -- 原客户账号
    ,P1.OLD_CCY -- 原币种代码
    ,P1.OLD_ACCT_SEQ_NO -- 原子账号
    ,P1.OLD_PROD_TYPE -- 原产品编号
    ,P1.OLD_CLIENT_NO -- 原客户编号
    ,P1.OLD_SETTLE_BASE_ACCT_NO -- 原利息入账客户账号
    ,P1.OLD_SETTLE_ACCT_CCY -- 原利息入账账户币种代码
    ,P1.OLD_SETTLE_ACCT_SEQ_NO -- 原利息入账子账号
    ,P1.OLD_SETTLE_PROD_TYPE -- 原利息入账账户产品编号
    ,P1.OLD_ACCT_NAME -- 原账户名称
    ,P1.OLD_SETTLE_ACCT_NAME -- 原利息入账账户名称
    ,P1.NEW_SETTLE_BASE_ACCT_NO -- 新利息入账客户账号
    ,P1.NEW_SETTLE_ACCT_CCY -- 新利息入账账户币种代码
    ,P1.NEW_SETTLE_ACCT_SEQ_NO -- 新利息入账子账号
    ,P1.NEW_SETTLE_PROD_TYPE -- 新利息入账账户产品编号
    ,P1.NEW_SETTLE_ACCT_NAME -- 新利息入账账户名称
    ,P1.BRANCH -- 交易机构编号
    ,${iml_schema}.dateformat_max2(P1.TRAN_DATE) -- 交易日期
    ,P1.STAGE_CODE -- 期次代码
    ,P1.STAGE_PROD_CLASS -- 期次产品类别代码
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.USER_ID -- 交易柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_dc_change_info' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_change_info p1
where  1 = 1 
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,acct_id
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
        into ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,init_cust_acct_num -- 原客户账号
    ,init_oc_cd -- 原币种代码
    ,init_sub_acct_num -- 原子账号
    ,init_prod_id -- 原产品编号
    ,init_cust_id -- 原客户编号
    ,init_int_enter_acct_cust_acct_num -- 原利息入账客户账号
    ,init_int_enter_curr_cd -- 原利息入账账户币种代码
    ,init_int_enter_acct_sub_acct_num -- 原利息入账子账号
    ,init_int_enter_prod_id -- 原利息入账账户产品编号
    ,init_acct_name -- 原账户名称
    ,init_int_enter_name -- 原利息入账账户名称
    ,new_int_enter_acct_cust_acct_num -- 新利息入账客户账号
    ,new_int_enter_curr_cd -- 新利息入账账户币种代码
    ,new_int_enter_acct_sub_acct_num -- 新利息入账子账号
    ,new_int_enter_prod_id -- 新利息入账账户产品编号
    ,new_int_enter_name -- 新利息入账账户名称
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,pd_cd -- 期次代码
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,auth_teller_id -- 授权柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,init_cust_acct_num -- 原客户账号
    ,init_oc_cd -- 原币种代码
    ,init_sub_acct_num -- 原子账号
    ,init_prod_id -- 原产品编号
    ,init_cust_id -- 原客户编号
    ,init_int_enter_acct_cust_acct_num -- 原利息入账客户账号
    ,init_int_enter_curr_cd -- 原利息入账账户币种代码
    ,init_int_enter_acct_sub_acct_num -- 原利息入账子账号
    ,init_int_enter_prod_id -- 原利息入账账户产品编号
    ,init_acct_name -- 原账户名称
    ,init_int_enter_name -- 原利息入账账户名称
    ,new_int_enter_acct_cust_acct_num -- 新利息入账客户账号
    ,new_int_enter_curr_cd -- 新利息入账账户币种代码
    ,new_int_enter_acct_sub_acct_num -- 新利息入账子账号
    ,new_int_enter_prod_id -- 新利息入账账户产品编号
    ,new_int_enter_name -- 新利息入账账户名称
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,pd_cd -- 期次代码
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,auth_teller_id -- 授权柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.acct_curr_cd, o.acct_curr_cd) as acct_curr_cd -- 账户币种代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.init_cust_acct_num, o.init_cust_acct_num) as init_cust_acct_num -- 原客户账号
    ,nvl(n.init_oc_cd, o.init_oc_cd) as init_oc_cd -- 原币种代码
    ,nvl(n.init_sub_acct_num, o.init_sub_acct_num) as init_sub_acct_num -- 原子账号
    ,nvl(n.init_prod_id, o.init_prod_id) as init_prod_id -- 原产品编号
    ,nvl(n.init_cust_id, o.init_cust_id) as init_cust_id -- 原客户编号
    ,nvl(n.init_int_enter_acct_cust_acct_num, o.init_int_enter_acct_cust_acct_num) as init_int_enter_acct_cust_acct_num -- 原利息入账客户账号
    ,nvl(n.init_int_enter_curr_cd, o.init_int_enter_curr_cd) as init_int_enter_curr_cd -- 原利息入账账户币种代码
    ,nvl(n.init_int_enter_acct_sub_acct_num, o.init_int_enter_acct_sub_acct_num) as init_int_enter_acct_sub_acct_num -- 原利息入账子账号
    ,nvl(n.init_int_enter_prod_id, o.init_int_enter_prod_id) as init_int_enter_prod_id -- 原利息入账账户产品编号
    ,nvl(n.init_acct_name, o.init_acct_name) as init_acct_name -- 原账户名称
    ,nvl(n.init_int_enter_name, o.init_int_enter_name) as init_int_enter_name -- 原利息入账账户名称
    ,nvl(n.new_int_enter_acct_cust_acct_num, o.new_int_enter_acct_cust_acct_num) as new_int_enter_acct_cust_acct_num -- 新利息入账客户账号
    ,nvl(n.new_int_enter_curr_cd, o.new_int_enter_curr_cd) as new_int_enter_curr_cd -- 新利息入账账户币种代码
    ,nvl(n.new_int_enter_acct_sub_acct_num, o.new_int_enter_acct_sub_acct_num) as new_int_enter_acct_sub_acct_num -- 新利息入账子账号
    ,nvl(n.new_int_enter_prod_id, o.new_int_enter_prod_id) as new_int_enter_prod_id -- 新利息入账账户产品编号
    ,nvl(n.new_int_enter_name, o.new_int_enter_name) as new_int_enter_name -- 新利息入账账户名称
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.pd_cd, o.pd_cd) as pd_cd -- 期次代码
    ,nvl(n.pd_prod_cate_cd, o.pd_prod_cate_cd) as pd_prod_cate_cd -- 期次产品类别代码
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,case when
            n.agt_id is null
            and n.acct_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.acct_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.acct_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.acct_id = n.acct_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.acct_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.acct_id is null
        and n.lp_id is null
    )
    or (
        o.cust_acct_num <> n.cust_acct_num
        or o.acct_curr_cd <> n.acct_curr_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.prod_id <> n.prod_id
        or o.acct_name <> n.acct_name
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.cust_id <> n.cust_id
        or o.init_cust_acct_num <> n.init_cust_acct_num
        or o.init_oc_cd <> n.init_oc_cd
        or o.init_sub_acct_num <> n.init_sub_acct_num
        or o.init_prod_id <> n.init_prod_id
        or o.init_cust_id <> n.init_cust_id
        or o.init_int_enter_acct_cust_acct_num <> n.init_int_enter_acct_cust_acct_num
        or o.init_int_enter_curr_cd <> n.init_int_enter_curr_cd
        or o.init_int_enter_acct_sub_acct_num <> n.init_int_enter_acct_sub_acct_num
        or o.init_int_enter_prod_id <> n.init_int_enter_prod_id
        or o.init_acct_name <> n.init_acct_name
        or o.init_int_enter_name <> n.init_int_enter_name
        or o.new_int_enter_acct_cust_acct_num <> n.new_int_enter_acct_cust_acct_num
        or o.new_int_enter_curr_cd <> n.new_int_enter_curr_cd
        or o.new_int_enter_acct_sub_acct_num <> n.new_int_enter_acct_sub_acct_num
        or o.new_int_enter_prod_id <> n.new_int_enter_prod_id
        or o.new_int_enter_name <> n.new_int_enter_name
        or o.tran_org_id <> n.tran_org_id
        or o.tran_dt <> n.tran_dt
        or o.pd_cd <> n.pd_cd
        or o.pd_prod_cate_cd <> n.pd_prod_cate_cd
        or o.auth_teller_id <> n.auth_teller_id
        or o.tran_tm <> n.tran_tm
        or o.tran_teller_id <> n.tran_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,init_cust_acct_num -- 原客户账号
    ,init_oc_cd -- 原币种代码
    ,init_sub_acct_num -- 原子账号
    ,init_prod_id -- 原产品编号
    ,init_cust_id -- 原客户编号
    ,init_int_enter_acct_cust_acct_num -- 原利息入账客户账号
    ,init_int_enter_curr_cd -- 原利息入账账户币种代码
    ,init_int_enter_acct_sub_acct_num -- 原利息入账子账号
    ,init_int_enter_prod_id -- 原利息入账账户产品编号
    ,init_acct_name -- 原账户名称
    ,init_int_enter_name -- 原利息入账账户名称
    ,new_int_enter_acct_cust_acct_num -- 新利息入账客户账号
    ,new_int_enter_curr_cd -- 新利息入账账户币种代码
    ,new_int_enter_acct_sub_acct_num -- 新利息入账子账号
    ,new_int_enter_prod_id -- 新利息入账账户产品编号
    ,new_int_enter_name -- 新利息入账账户名称
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,pd_cd -- 期次代码
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,auth_teller_id -- 授权柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_op(
            agt_id -- 协议编号
    ,acct_id -- 账户编号
    ,lp_id -- 法人编号
    ,cust_acct_num -- 客户账号
    ,acct_curr_cd -- 账户币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,init_cust_acct_num -- 原客户账号
    ,init_oc_cd -- 原币种代码
    ,init_sub_acct_num -- 原子账号
    ,init_prod_id -- 原产品编号
    ,init_cust_id -- 原客户编号
    ,init_int_enter_acct_cust_acct_num -- 原利息入账客户账号
    ,init_int_enter_curr_cd -- 原利息入账账户币种代码
    ,init_int_enter_acct_sub_acct_num -- 原利息入账子账号
    ,init_int_enter_prod_id -- 原利息入账账户产品编号
    ,init_acct_name -- 原账户名称
    ,init_int_enter_name -- 原利息入账账户名称
    ,new_int_enter_acct_cust_acct_num -- 新利息入账客户账号
    ,new_int_enter_curr_cd -- 新利息入账账户币种代码
    ,new_int_enter_acct_sub_acct_num -- 新利息入账子账号
    ,new_int_enter_prod_id -- 新利息入账账户产品编号
    ,new_int_enter_name -- 新利息入账账户名称
    ,tran_org_id -- 交易机构编号
    ,tran_dt -- 交易日期
    ,pd_cd -- 期次代码
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,auth_teller_id -- 授权柜员编号
    ,tran_tm -- 交易时间
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.acct_id -- 账户编号
    ,o.lp_id -- 法人编号
    ,o.cust_acct_num -- 客户账号
    ,o.acct_curr_cd -- 账户币种代码
    ,o.sub_acct_num -- 子账号
    ,o.prod_id -- 产品编号
    ,o.acct_name -- 账户名称
    ,o.open_acct_org_id -- 开户机构编号
    ,o.cust_id -- 客户编号
    ,o.init_cust_acct_num -- 原客户账号
    ,o.init_oc_cd -- 原币种代码
    ,o.init_sub_acct_num -- 原子账号
    ,o.init_prod_id -- 原产品编号
    ,o.init_cust_id -- 原客户编号
    ,o.init_int_enter_acct_cust_acct_num -- 原利息入账客户账号
    ,o.init_int_enter_curr_cd -- 原利息入账账户币种代码
    ,o.init_int_enter_acct_sub_acct_num -- 原利息入账子账号
    ,o.init_int_enter_prod_id -- 原利息入账账户产品编号
    ,o.init_acct_name -- 原账户名称
    ,o.init_int_enter_name -- 原利息入账账户名称
    ,o.new_int_enter_acct_cust_acct_num -- 新利息入账客户账号
    ,o.new_int_enter_curr_cd -- 新利息入账账户币种代码
    ,o.new_int_enter_acct_sub_acct_num -- 新利息入账子账号
    ,o.new_int_enter_prod_id -- 新利息入账账户产品编号
    ,o.new_int_enter_name -- 新利息入账账户名称
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_dt -- 交易日期
    ,o.pd_cd -- 期次代码
    ,o.pd_prod_cate_cd -- 期次产品类别代码
    ,o.auth_teller_id -- 授权柜员编号
    ,o.tran_tm -- 交易时间
    ,o.tran_teller_id -- 交易柜员编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_bk o
    left join ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.acct_id = n.acct_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.acct_id = d.acct_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cds_transf_agt_h;
alter table ${iml_schema}.agt_cds_transf_agt_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_cds_transf_agt_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_cl;
alter table ${iml_schema}.agt_cds_transf_agt_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cds_transf_agt_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cds_transf_agt_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cds_transf_agt_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
