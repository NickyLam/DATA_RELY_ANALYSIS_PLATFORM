/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lhwd_crdt_appl_icmsf1
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
alter table ${iml_schema}.agt_lhwd_crdt_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_crdt_appl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_id -- 授信编号
    ,appl_amt -- 申请金额
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,crdt_chn_cd -- 授信渠道代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,circl_flg -- 循环标志
    ,main_guar_way_cd -- 主担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,bank_contri_ratio -- 银行出资比例
    ,apv_start_dt -- 审批开始日期
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs_descb -- 风控拒绝原因描述
    ,risk_mgmt_return_dt -- 风控返回日期
    ,manu_apv_flg -- 人工审批标志
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,partner_apv_status_cd -- 合作方审批状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lhwd_crdt_appl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_crdt_appl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lhwd_crdt_appl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_lhwd_business_apply-1
insert into ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_id -- 授信编号
    ,appl_amt -- 申请金额
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,crdt_chn_cd -- 授信渠道代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,circl_flg -- 循环标志
    ,main_guar_way_cd -- 主担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,bank_contri_ratio -- 银行出资比例
    ,apv_start_dt -- 审批开始日期
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs_descb -- 风控拒绝原因描述
    ,risk_mgmt_return_dt -- 风控返回日期
    ,manu_apv_flg -- 人工审批标志
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,partner_apv_status_cd -- 合作方审批状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206018'||P1.SERIALNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 授信编号
    ,P1.BUSINESSSUM -- 申请金额
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 申请状态代码
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,nvl(trim(P1.CREDITCHANNEL),'-') -- 授信渠道代码
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.TERMMONTH -- 月期限
    ,P1.TERMDAY -- 日期限
    ,nvl(trim(P1.ISCYCLE),'-') -- 循环标志
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,nvl(trim(P1.NATIONALINDUSTRYTYPE),'-') -- 贷款投向行业代码
    ,nvl(trim(P1.LOANUSETYPE),'000000') -- 贷款用途代码
    ,P1.BANKCONTRIRATIO -- 银行出资比例
    ,P1.APVSTARTTM -- 审批开始日期
    ,P1.APVAMT -- 风控授信额度
    ,P1.REFUSECODE -- 风控拒绝码
    ,P1.REFUSEREASON -- 风控拒绝原因描述
    ,P1.ACCEPTRISKTIME -- 风控返回日期
    ,nvl(trim(P1.MANUALAPPROVAL),'-') -- 人工审批标志
    ,P1.PRODUCTNO -- 合作方产品编号
    ,P1.APPLYNO -- 合作方全局流水号
    ,nvl(trim(P1.BUSINESSMODEL),'-') -- 合作方业务模式代码
    ,nvl(trim(P1.PARTNERAPVRESTFLG),'-') -- 合作方审批状态代码
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最新更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_lhwd_business_apply' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_lhwd_business_apply p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                                        ,crdt_id
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
        into ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_id -- 授信编号
    ,appl_amt -- 申请金额
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,crdt_chn_cd -- 授信渠道代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,circl_flg -- 循环标志
    ,main_guar_way_cd -- 主担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,bank_contri_ratio -- 银行出资比例
    ,apv_start_dt -- 审批开始日期
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs_descb -- 风控拒绝原因描述
    ,risk_mgmt_return_dt -- 风控返回日期
    ,manu_apv_flg -- 人工审批标志
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,partner_apv_status_cd -- 合作方审批状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_id -- 授信编号
    ,appl_amt -- 申请金额
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,crdt_chn_cd -- 授信渠道代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,circl_flg -- 循环标志
    ,main_guar_way_cd -- 主担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,bank_contri_ratio -- 银行出资比例
    ,apv_start_dt -- 审批开始日期
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs_descb -- 风控拒绝原因描述
    ,risk_mgmt_return_dt -- 风控返回日期
    ,manu_apv_flg -- 人工审批标志
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,partner_apv_status_cd -- 合作方审批状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.crdt_id, o.crdt_id) as crdt_id -- 授信编号
    ,nvl(n.appl_amt, o.appl_amt) as appl_amt -- 申请金额
    ,nvl(n.appl_status_cd, o.appl_status_cd) as appl_status_cd -- 申请状态代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.crdt_chn_cd, o.crdt_chn_cd) as crdt_chn_cd -- 授信渠道代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.day_tenor, o.day_tenor) as day_tenor -- 日期限
    ,nvl(n.circl_flg, o.circl_flg) as circl_flg -- 循环标志
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.loan_dir_indus_cd, o.loan_dir_indus_cd) as loan_dir_indus_cd -- 贷款投向行业代码
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.bank_contri_ratio, o.bank_contri_ratio) as bank_contri_ratio -- 银行出资比例
    ,nvl(n.apv_start_dt, o.apv_start_dt) as apv_start_dt -- 审批开始日期
    ,nvl(n.risk_mgmt_crdt_lmt, o.risk_mgmt_crdt_lmt) as risk_mgmt_crdt_lmt -- 风控授信额度
    ,nvl(n.risk_mgmt_refuse_code, o.risk_mgmt_refuse_code) as risk_mgmt_refuse_code -- 风控拒绝码
    ,nvl(n.risk_mgmt_refuse_rs_descb, o.risk_mgmt_refuse_rs_descb) as risk_mgmt_refuse_rs_descb -- 风控拒绝原因描述
    ,nvl(n.risk_mgmt_return_dt, o.risk_mgmt_return_dt) as risk_mgmt_return_dt -- 风控返回日期
    ,nvl(n.manu_apv_flg, o.manu_apv_flg) as manu_apv_flg -- 人工审批标志
    ,nvl(n.partner_prod_id, o.partner_prod_id) as partner_prod_id -- 合作方产品编号
    ,nvl(n.partner_ova_flow_num, o.partner_ova_flow_num) as partner_ova_flow_num -- 合作方全局流水号
    ,nvl(n.partner_bus_mode_cd, o.partner_bus_mode_cd) as partner_bus_mode_cd -- 合作方业务模式代码
    ,nvl(n.partner_apv_status_cd, o.partner_apv_status_cd) as partner_apv_status_cd -- 合作方审批状态代码
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.latest_update_dt, o.latest_update_dt) as latest_update_dt -- 最新更新日期
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.crdt_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.crdt_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.crdt_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.crdt_id = n.crdt_id
where (
        o.appl_id is null
        and o.lp_id is null
        and o.crdt_id is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
        and n.crdt_id is null
    )
    or (
        o.appl_amt <> n.appl_amt
        or o.appl_status_cd <> n.appl_status_cd
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.crdt_chn_cd <> n.crdt_chn_cd
        or o.prod_id <> n.prod_id
        or o.curr_cd <> n.curr_cd
        or o.mon_tenor <> n.mon_tenor
        or o.day_tenor <> n.day_tenor
        or o.circl_flg <> n.circl_flg
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.loan_dir_indus_cd <> n.loan_dir_indus_cd
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.bank_contri_ratio <> n.bank_contri_ratio
        or o.apv_start_dt <> n.apv_start_dt
        or o.risk_mgmt_crdt_lmt <> n.risk_mgmt_crdt_lmt
        or o.risk_mgmt_refuse_code <> n.risk_mgmt_refuse_code
        or o.risk_mgmt_refuse_rs_descb <> n.risk_mgmt_refuse_rs_descb
        or o.risk_mgmt_return_dt <> n.risk_mgmt_return_dt
        or o.manu_apv_flg <> n.manu_apv_flg
        or o.partner_prod_id <> n.partner_prod_id
        or o.partner_ova_flow_num <> n.partner_ova_flow_num
        or o.partner_bus_mode_cd <> n.partner_bus_mode_cd
        or o.partner_apv_status_cd <> n.partner_apv_status_cd
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.latest_update_dt <> n.latest_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_id -- 授信编号
    ,appl_amt -- 申请金额
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,crdt_chn_cd -- 授信渠道代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,circl_flg -- 循环标志
    ,main_guar_way_cd -- 主担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,bank_contri_ratio -- 银行出资比例
    ,apv_start_dt -- 审批开始日期
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs_descb -- 风控拒绝原因描述
    ,risk_mgmt_return_dt -- 风控返回日期
    ,manu_apv_flg -- 人工审批标志
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,partner_apv_status_cd -- 合作方审批状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,crdt_id -- 授信编号
    ,appl_amt -- 申请金额
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,crdt_chn_cd -- 授信渠道代码
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,circl_flg -- 循环标志
    ,main_guar_way_cd -- 主担保方式代码
    ,loan_dir_indus_cd -- 贷款投向行业代码
    ,loan_usage_cd -- 贷款用途代码
    ,bank_contri_ratio -- 银行出资比例
    ,apv_start_dt -- 审批开始日期
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_refuse_code -- 风控拒绝码
    ,risk_mgmt_refuse_rs_descb -- 风控拒绝原因描述
    ,risk_mgmt_return_dt -- 风控返回日期
    ,manu_apv_flg -- 人工审批标志
    ,partner_prod_id -- 合作方产品编号
    ,partner_ova_flow_num -- 合作方全局流水号
    ,partner_bus_mode_cd -- 合作方业务模式代码
    ,partner_apv_status_cd -- 合作方审批状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,latest_update_dt -- 最新更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appl_id -- 申请编号
    ,o.lp_id -- 法人编号
    ,o.crdt_id -- 授信编号
    ,o.appl_amt -- 申请金额
    ,o.appl_status_cd -- 申请状态代码
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.crdt_chn_cd -- 授信渠道代码
    ,o.prod_id -- 产品编号
    ,o.curr_cd -- 币种代码
    ,o.mon_tenor -- 月期限
    ,o.day_tenor -- 日期限
    ,o.circl_flg -- 循环标志
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.loan_dir_indus_cd -- 贷款投向行业代码
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.bank_contri_ratio -- 银行出资比例
    ,o.apv_start_dt -- 审批开始日期
    ,o.risk_mgmt_crdt_lmt -- 风控授信额度
    ,o.risk_mgmt_refuse_code -- 风控拒绝码
    ,o.risk_mgmt_refuse_rs_descb -- 风控拒绝原因描述
    ,o.risk_mgmt_return_dt -- 风控返回日期
    ,o.manu_apv_flg -- 人工审批标志
    ,o.partner_prod_id -- 合作方产品编号
    ,o.partner_ova_flow_num -- 合作方全局流水号
    ,o.partner_bus_mode_cd -- 合作方业务模式代码
    ,o.partner_apv_status_cd -- 合作方审批状态代码
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.latest_update_dt -- 最新更新日期
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
from ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_bk o
    left join ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.crdt_id = n.crdt_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.crdt_id = d.crdt_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lhwd_crdt_appl;
--alter table ${iml_schema}.agt_lhwd_crdt_appl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lhwd_crdt_appl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lhwd_crdt_appl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lhwd_crdt_appl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lhwd_crdt_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_cl;
alter table ${iml_schema}.agt_lhwd_crdt_appl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lhwd_crdt_appl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lhwd_crdt_appl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lhwd_crdt_appl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
