/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_dep_wdraw_precon_info_h_ncbsf1
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
alter table ${iml_schema}.agt_dep_wdraw_precon_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_wdraw_precon_info_h partition for ('ncbsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,precon_curr_cd -- 预约币种代码
    ,draw_dt -- 取款日期
    ,tran_org_id -- 交易机构编号
    ,precon_amt -- 预约金额
    ,precon_mode_cd -- 预约模式代码
    ,acct_type_cd -- 账户类型代码
    ,precon_wdraw_way_cd -- 预约支取方式代码
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,precon_rgst_dt -- 预约登记日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,tel_num -- 电话号码
    ,advise_dep_deflt_base -- 通知存款违约基数
    ,tran_tm -- 交易时间
    ,unloss_teller_id -- 解挂柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_wdraw_precon_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_wdraw_precon_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_dep_wdraw_precon_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_precontract-1
insert into ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,precon_curr_cd -- 预约币种代码
    ,draw_dt -- 取款日期
    ,tran_org_id -- 交易机构编号
    ,precon_amt -- 预约金额
    ,precon_mode_cd -- 预约模式代码
    ,acct_type_cd -- 账户类型代码
    ,precon_wdraw_way_cd -- 预约支取方式代码
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,precon_rgst_dt -- 预约登记日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,tel_num -- 电话号码
    ,advise_dep_deflt_base -- 通知存款违约基数
    ,tran_tm -- 交易时间
    ,unloss_teller_id -- 解挂柜员编号
    ,tran_teller_id -- 交易柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101043'||P1.PRECONTRACT_NO||P1.INTERNAL_KEY||P1.PRECONTRACT_CCY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PRECONTRACT_NO -- 预约编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.PRECONTRACT_CCY -- 预约币种代码
    ,P1.PRECONTRACT_DRAW_DATE -- 取款日期
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.PRECONTRACT_AMT -- 预约金额
    ,P1.PRECONTRACT_METHOD -- 预约模式代码
    ,P1.PRECONTRACT_TYPE -- 账户类型代码
    ,P1.PRECONTRACT_WTD_TYPE -- 预约支取方式代码
    ,P1.PRECONTRACT_STATUS -- 期次产品预约状态代码
    ,P1.PRECONTRACT_DATE -- 预约登记日期
    ,P1.CLIENT_NO -- 客户编号
    ,P1.CLIENT_NAME -- 客户名称
    ,P1.PROD_TYPE -- 产品编号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.REFERENCE -- 交易参考号
    ,P1.CCY -- 币种代码
    ,P1.MOBILE_NO -- 电话号码
    ,P1.VIOLATE_ADJ -- 通知存款违约基数
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.UNLOST_USER_ID -- 解挂柜员编号
    ,P1.USER_ID -- 交易柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_precontract' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_precontract p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,precon_id
  	                                        ,acct_id
  	                                        ,precon_curr_cd
  	                                        ,draw_dt
  	                                        ,tran_org_id
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
        into ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,precon_curr_cd -- 预约币种代码
    ,draw_dt -- 取款日期
    ,tran_org_id -- 交易机构编号
    ,precon_amt -- 预约金额
    ,precon_mode_cd -- 预约模式代码
    ,acct_type_cd -- 账户类型代码
    ,precon_wdraw_way_cd -- 预约支取方式代码
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,precon_rgst_dt -- 预约登记日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,tel_num -- 电话号码
    ,advise_dep_deflt_base -- 通知存款违约基数
    ,tran_tm -- 交易时间
    ,unloss_teller_id -- 解挂柜员编号
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,precon_curr_cd -- 预约币种代码
    ,draw_dt -- 取款日期
    ,tran_org_id -- 交易机构编号
    ,precon_amt -- 预约金额
    ,precon_mode_cd -- 预约模式代码
    ,acct_type_cd -- 账户类型代码
    ,precon_wdraw_way_cd -- 预约支取方式代码
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,precon_rgst_dt -- 预约登记日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,tel_num -- 电话号码
    ,advise_dep_deflt_base -- 通知存款违约基数
    ,tran_tm -- 交易时间
    ,unloss_teller_id -- 解挂柜员编号
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
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.precon_id, o.precon_id) as precon_id -- 预约编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.precon_curr_cd, o.precon_curr_cd) as precon_curr_cd -- 预约币种代码
    ,nvl(n.draw_dt, o.draw_dt) as draw_dt -- 取款日期
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.precon_amt, o.precon_amt) as precon_amt -- 预约金额
    ,nvl(n.precon_mode_cd, o.precon_mode_cd) as precon_mode_cd -- 预约模式代码
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.precon_wdraw_way_cd, o.precon_wdraw_way_cd) as precon_wdraw_way_cd -- 预约支取方式代码
    ,nvl(n.pd_prod_precon_status_cd, o.pd_prod_precon_status_cd) as pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,nvl(n.precon_rgst_dt, o.precon_rgst_dt) as precon_rgst_dt -- 预约登记日期
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.tel_num, o.tel_num) as tel_num -- 电话号码
    ,nvl(n.advise_dep_deflt_base, o.advise_dep_deflt_base) as advise_dep_deflt_base -- 通知存款违约基数
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.unloss_teller_id, o.unloss_teller_id) as unloss_teller_id -- 解挂柜员编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.precon_id is null
            and n.acct_id is null
            and n.precon_curr_cd is null
            and n.draw_dt is null
            and n.tran_org_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.precon_id is null
            and n.acct_id is null
            and n.precon_curr_cd is null
            and n.draw_dt is null
            and n.tran_org_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.precon_id is null
            and n.acct_id is null
            and n.precon_curr_cd is null
            and n.draw_dt is null
            and n.tran_org_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.precon_id = n.precon_id
            and o.acct_id = n.acct_id
            and o.precon_curr_cd = n.precon_curr_cd
            and o.draw_dt = n.draw_dt
            and o.tran_org_id = n.tran_org_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.precon_id is null
        and o.acct_id is null
        and o.precon_curr_cd is null
        and o.draw_dt is null
        and o.tran_org_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.precon_id is null
        and n.acct_id is null
        and n.precon_curr_cd is null
        and n.draw_dt is null
        and n.tran_org_id is null
    )
    or (
        o.precon_amt <> n.precon_amt
        or o.precon_mode_cd <> n.precon_mode_cd
        or o.acct_type_cd <> n.acct_type_cd
        or o.precon_wdraw_way_cd <> n.precon_wdraw_way_cd
        or o.pd_prod_precon_status_cd <> n.pd_prod_precon_status_cd
        or o.precon_rgst_dt <> n.precon_rgst_dt
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.prod_id <> n.prod_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.sub_acct_num <> n.sub_acct_num
        or o.acct_name <> n.acct_name
        or o.tran_ref_no <> n.tran_ref_no
        or o.curr_cd <> n.curr_cd
        or o.tel_num <> n.tel_num
        or o.advise_dep_deflt_base <> n.advise_dep_deflt_base
        or o.tran_tm <> n.tran_tm
        or o.unloss_teller_id <> n.unloss_teller_id
        or o.tran_teller_id <> n.tran_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,precon_curr_cd -- 预约币种代码
    ,draw_dt -- 取款日期
    ,tran_org_id -- 交易机构编号
    ,precon_amt -- 预约金额
    ,precon_mode_cd -- 预约模式代码
    ,acct_type_cd -- 账户类型代码
    ,precon_wdraw_way_cd -- 预约支取方式代码
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,precon_rgst_dt -- 预约登记日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,tel_num -- 电话号码
    ,advise_dep_deflt_base -- 通知存款违约基数
    ,tran_tm -- 交易时间
    ,unloss_teller_id -- 解挂柜员编号
    ,tran_teller_id -- 交易柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,acct_id -- 账户编号
    ,precon_curr_cd -- 预约币种代码
    ,draw_dt -- 取款日期
    ,tran_org_id -- 交易机构编号
    ,precon_amt -- 预约金额
    ,precon_mode_cd -- 预约模式代码
    ,acct_type_cd -- 账户类型代码
    ,precon_wdraw_way_cd -- 预约支取方式代码
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,precon_rgst_dt -- 预约登记日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,cust_acct_num -- 客户账号
    ,sub_acct_num -- 子账号
    ,acct_name -- 账户名称
    ,tran_ref_no -- 交易参考号
    ,curr_cd -- 币种代码
    ,tel_num -- 电话号码
    ,advise_dep_deflt_base -- 通知存款违约基数
    ,tran_tm -- 交易时间
    ,unloss_teller_id -- 解挂柜员编号
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
    ,o.lp_id -- 法人编号
    ,o.precon_id -- 预约编号
    ,o.acct_id -- 账户编号
    ,o.precon_curr_cd -- 预约币种代码
    ,o.draw_dt -- 取款日期
    ,o.tran_org_id -- 交易机构编号
    ,o.precon_amt -- 预约金额
    ,o.precon_mode_cd -- 预约模式代码
    ,o.acct_type_cd -- 账户类型代码
    ,o.precon_wdraw_way_cd -- 预约支取方式代码
    ,o.pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,o.precon_rgst_dt -- 预约登记日期
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.prod_id -- 产品编号
    ,o.cust_acct_num -- 客户账号
    ,o.sub_acct_num -- 子账号
    ,o.acct_name -- 账户名称
    ,o.tran_ref_no -- 交易参考号
    ,o.curr_cd -- 币种代码
    ,o.tel_num -- 电话号码
    ,o.advise_dep_deflt_base -- 通知存款违约基数
    ,o.tran_tm -- 交易时间
    ,o.unloss_teller_id -- 解挂柜员编号
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
from ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.precon_id = n.precon_id
            and o.acct_id = n.acct_id
            and o.precon_curr_cd = n.precon_curr_cd
            and o.draw_dt = n.draw_dt
            and o.tran_org_id = n.tran_org_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.precon_id = d.precon_id
            and o.acct_id = d.acct_id
            and o.precon_curr_cd = d.precon_curr_cd
            and o.draw_dt = d.draw_dt
            and o.tran_org_id = d.tran_org_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_dep_wdraw_precon_info_h;
alter table ${iml_schema}.agt_dep_wdraw_precon_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.agt_dep_wdraw_precon_info_h exchange subpartition p_ncbsf1_19000101 with table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_dep_wdraw_precon_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_dep_wdraw_precon_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_dep_wdraw_precon_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_dep_wdraw_precon_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
