/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wph_crdt_appl_icmsf1
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
alter table ${iml_schema}.agt_wph_crdt_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wph_crdt_appl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_crdt_appl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_wph_crdt_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_wph_crdt_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_wph_crdt_appl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wph_crdt_appl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,appl_status_cd -- 申请状态代码
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_perds -- 贷款期数
    ,lmt_type_cd -- 额度类型代码
    ,appl_tot_amt -- 申请总额度
    ,partner_promis_loan_amt -- 合作方承贷金额
    ,lmt_effect_dt -- 额度生效日期
    ,lmt_invalid_dt -- 额度失效日期
    ,year_int_rat -- 年利率
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,custs_cd -- 客群代码
    ,mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,career_cd -- 职业代码
    ,title_cd -- 职称代码
    ,bus_type_cd -- 业务类型代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_dt -- 风控回调日期
    ,risk_mgmt_remark -- 风控备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wph_crdt_appl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_wph_crdt_appl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_crdt_appl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_wph_crdt_appl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wph_crdt_appl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_wph_business_apply-1
insert into ${iml_schema}.agt_wph_crdt_appl_icmsf1_tm(
    appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,appl_status_cd -- 申请状态代码
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_perds -- 贷款期数
    ,lmt_type_cd -- 额度类型代码
    ,appl_tot_amt -- 申请总额度
    ,partner_promis_loan_amt -- 合作方承贷金额
    ,lmt_effect_dt -- 额度生效日期
    ,lmt_invalid_dt -- 额度失效日期
    ,year_int_rat -- 年利率
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,custs_cd -- 客群代码
    ,mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,career_cd -- 职业代码
    ,title_cd -- 职称代码
    ,bus_type_cd -- 业务类型代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_dt -- 风控回调日期
    ,risk_mgmt_remark -- 风控备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206014'||P1.CREDITAPPNO -- 申请编号
    ,'9999' -- 法人编号
    ,P1.CREDITAPPNO -- 申请流水号
    ,P1.APPLYID -- 源申请流水号
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 申请状态代码
    ,P1.PARTNERCODE -- 机构编号
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim(P1.LOANTYPE),'-') -- 贷款类型代码
    ,nvl(trim(P1.LOANUSE),'-') -- 贷款用途代码
    ,to_number(nvl(trim(P1.TENOR),'0')) -- 贷款期数
    ,nvl(trim(P1.AMOUNTTYPE),'-') -- 额度类型代码
    ,P1.CREDITLIMIT -- 申请总额度
    ,P1.CREDITLIMITCROP -- 合作方承贷金额
    ,${iml_schema}.dateformat_min(P1.STARTDATE) -- 额度生效日期
    ,${iml_schema}.dateformat_max(P1.ENDDATE) -- 额度失效日期
    ,P1.ADVICERATE -- 年利率
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CHINESENAME -- 客户名称
    ,P1.CUSTOMERGROUP -- 客群代码
    ,P1.MOBILE -- 手机号码
    ,nvl(trim(P1.IDTYPE),'0000') -- 证件类型代码
    ,P1.IDNUMBER -- 证件号码
    ,P1.OCCUPATION -- 职业代码
    ,P1.TITLE -- 职称代码
    ,P1.BUSINESSTYPE -- 业务类型代码
    ,nvl(trim(P1.RISKSTATUS),'-') -- 风控结果代码
    ,P1.FAILREASON -- 风控拒绝原因
    ,P1.RISKCREDITAMOUNT -- 风控授信额度
    ,P1.RISKINTRATE -- 风控利息年利率
    ,P1.RISKREQTIME -- 风控回调日期
    ,P1.PDCUSTDATA -- 风控备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wph_business_apply' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wph_business_apply p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wph_crdt_appl_icmsf1_tm 
  	                                group by 
  	                                        appl_id
  	                                        ,lp_id
  	                                        ,appl_flow_num
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
        into ${iml_schema}.agt_wph_crdt_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,appl_status_cd -- 申请状态代码
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_perds -- 贷款期数
    ,lmt_type_cd -- 额度类型代码
    ,appl_tot_amt -- 申请总额度
    ,partner_promis_loan_amt -- 合作方承贷金额
    ,lmt_effect_dt -- 额度生效日期
    ,lmt_invalid_dt -- 额度失效日期
    ,year_int_rat -- 年利率
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,custs_cd -- 客群代码
    ,mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,career_cd -- 职业代码
    ,title_cd -- 职称代码
    ,bus_type_cd -- 业务类型代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_dt -- 风控回调日期
    ,risk_mgmt_remark -- 风控备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wph_crdt_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,appl_status_cd -- 申请状态代码
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_perds -- 贷款期数
    ,lmt_type_cd -- 额度类型代码
    ,appl_tot_amt -- 申请总额度
    ,partner_promis_loan_amt -- 合作方承贷金额
    ,lmt_effect_dt -- 额度生效日期
    ,lmt_invalid_dt -- 额度失效日期
    ,year_int_rat -- 年利率
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,custs_cd -- 客群代码
    ,mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,career_cd -- 职业代码
    ,title_cd -- 职称代码
    ,bus_type_cd -- 业务类型代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_dt -- 风控回调日期
    ,risk_mgmt_remark -- 风控备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
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
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.src_appl_flow_num, o.src_appl_flow_num) as src_appl_flow_num -- 源申请流水号
    ,nvl(n.appl_status_cd, o.appl_status_cd) as appl_status_cd -- 申请状态代码
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.loan_type_cd, o.loan_type_cd) as loan_type_cd -- 贷款类型代码
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.loan_perds, o.loan_perds) as loan_perds -- 贷款期数
    ,nvl(n.lmt_type_cd, o.lmt_type_cd) as lmt_type_cd -- 额度类型代码
    ,nvl(n.appl_tot_amt, o.appl_tot_amt) as appl_tot_amt -- 申请总额度
    ,nvl(n.partner_promis_loan_amt, o.partner_promis_loan_amt) as partner_promis_loan_amt -- 合作方承贷金额
    ,nvl(n.lmt_effect_dt, o.lmt_effect_dt) as lmt_effect_dt -- 额度生效日期
    ,nvl(n.lmt_invalid_dt, o.lmt_invalid_dt) as lmt_invalid_dt -- 额度失效日期
    ,nvl(n.year_int_rat, o.year_int_rat) as year_int_rat -- 年利率
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.custs_cd, o.custs_cd) as custs_cd -- 客群代码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.career_cd, o.career_cd) as career_cd -- 职业代码
    ,nvl(n.title_cd, o.title_cd) as title_cd -- 职称代码
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.risk_mgmt_rest_cd, o.risk_mgmt_rest_cd) as risk_mgmt_rest_cd -- 风控结果代码
    ,nvl(n.risk_mgmt_refuse_rs, o.risk_mgmt_refuse_rs) as risk_mgmt_refuse_rs -- 风控拒绝原因
    ,nvl(n.risk_mgmt_crdt_lmt, o.risk_mgmt_crdt_lmt) as risk_mgmt_crdt_lmt -- 风控授信额度
    ,nvl(n.risk_mgmt_int_year_int_rat, o.risk_mgmt_int_year_int_rat) as risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,nvl(n.risk_mgmt_dt, o.risk_mgmt_dt) as risk_mgmt_dt -- 风控回调日期
    ,nvl(n.risk_mgmt_remark, o.risk_mgmt_remark) as risk_mgmt_remark -- 风控备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.appl_flow_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.appl_flow_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appl_id is null
            and n.lp_id is null
            and n.appl_flow_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wph_crdt_appl_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_wph_crdt_appl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.appl_flow_num = n.appl_flow_num
where (
        o.appl_id is null
        and o.lp_id is null
        and o.appl_flow_num is null
    )
    or (
        n.appl_id is null
        and n.lp_id is null
        and n.appl_flow_num is null
    )
    or (
        o.src_appl_flow_num <> n.src_appl_flow_num
        or o.appl_status_cd <> n.appl_status_cd
        or o.org_id <> n.org_id
        or o.prod_id <> n.prod_id
        or o.loan_type_cd <> n.loan_type_cd
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.loan_perds <> n.loan_perds
        or o.lmt_type_cd <> n.lmt_type_cd
        or o.appl_tot_amt <> n.appl_tot_amt
        or o.partner_promis_loan_amt <> n.partner_promis_loan_amt
        or o.lmt_effect_dt <> n.lmt_effect_dt
        or o.lmt_invalid_dt <> n.lmt_invalid_dt
        or o.year_int_rat <> n.year_int_rat
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.custs_cd <> n.custs_cd
        or o.mobile_no <> n.mobile_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.career_cd <> n.career_cd
        or o.title_cd <> n.title_cd
        or o.bus_type_cd <> n.bus_type_cd
        or o.risk_mgmt_rest_cd <> n.risk_mgmt_rest_cd
        or o.risk_mgmt_refuse_rs <> n.risk_mgmt_refuse_rs
        or o.risk_mgmt_crdt_lmt <> n.risk_mgmt_crdt_lmt
        or o.risk_mgmt_int_year_int_rat <> n.risk_mgmt_int_year_int_rat
        or o.risk_mgmt_dt <> n.risk_mgmt_dt
        or o.risk_mgmt_remark <> n.risk_mgmt_remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_wph_crdt_appl_icmsf1_cl(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,appl_status_cd -- 申请状态代码
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_perds -- 贷款期数
    ,lmt_type_cd -- 额度类型代码
    ,appl_tot_amt -- 申请总额度
    ,partner_promis_loan_amt -- 合作方承贷金额
    ,lmt_effect_dt -- 额度生效日期
    ,lmt_invalid_dt -- 额度失效日期
    ,year_int_rat -- 年利率
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,custs_cd -- 客群代码
    ,mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,career_cd -- 职业代码
    ,title_cd -- 职称代码
    ,bus_type_cd -- 业务类型代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_dt -- 风控回调日期
    ,risk_mgmt_remark -- 风控备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_wph_crdt_appl_icmsf1_op(
            appl_id -- 申请编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,src_appl_flow_num -- 源申请流水号
    ,appl_status_cd -- 申请状态代码
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,loan_type_cd -- 贷款类型代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_perds -- 贷款期数
    ,lmt_type_cd -- 额度类型代码
    ,appl_tot_amt -- 申请总额度
    ,partner_promis_loan_amt -- 合作方承贷金额
    ,lmt_effect_dt -- 额度生效日期
    ,lmt_invalid_dt -- 额度失效日期
    ,year_int_rat -- 年利率
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,custs_cd -- 客群代码
    ,mobile_no -- 手机号码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,career_cd -- 职业代码
    ,title_cd -- 职称代码
    ,bus_type_cd -- 业务类型代码
    ,risk_mgmt_rest_cd -- 风控结果代码
    ,risk_mgmt_refuse_rs -- 风控拒绝原因
    ,risk_mgmt_crdt_lmt -- 风控授信额度
    ,risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,risk_mgmt_dt -- 风控回调日期
    ,risk_mgmt_remark -- 风控备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
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
    ,o.appl_flow_num -- 申请流水号
    ,o.src_appl_flow_num -- 源申请流水号
    ,o.appl_status_cd -- 申请状态代码
    ,o.org_id -- 机构编号
    ,o.prod_id -- 产品编号
    ,o.loan_type_cd -- 贷款类型代码
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.loan_perds -- 贷款期数
    ,o.lmt_type_cd -- 额度类型代码
    ,o.appl_tot_amt -- 申请总额度
    ,o.partner_promis_loan_amt -- 合作方承贷金额
    ,o.lmt_effect_dt -- 额度生效日期
    ,o.lmt_invalid_dt -- 额度失效日期
    ,o.year_int_rat -- 年利率
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.custs_cd -- 客群代码
    ,o.mobile_no -- 手机号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.career_cd -- 职业代码
    ,o.title_cd -- 职称代码
    ,o.bus_type_cd -- 业务类型代码
    ,o.risk_mgmt_rest_cd -- 风控结果代码
    ,o.risk_mgmt_refuse_rs -- 风控拒绝原因
    ,o.risk_mgmt_crdt_lmt -- 风控授信额度
    ,o.risk_mgmt_int_year_int_rat -- 风控利息年利率
    ,o.risk_mgmt_dt -- 风控回调日期
    ,o.risk_mgmt_remark -- 风控备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.agt_wph_crdt_appl_icmsf1_bk o
    left join ${iml_schema}.agt_wph_crdt_appl_icmsf1_op n
        on
            o.appl_id = n.appl_id
            and o.lp_id = n.lp_id
            and o.appl_flow_num = n.appl_flow_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_wph_crdt_appl_icmsf1_cl d
        on
            o.appl_id = d.appl_id
            and o.lp_id = d.lp_id
            and o.appl_flow_num = d.appl_flow_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_wph_crdt_appl;
--alter table ${iml_schema}.agt_wph_crdt_appl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_wph_crdt_appl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_wph_crdt_appl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_wph_crdt_appl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_wph_crdt_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_wph_crdt_appl_icmsf1_cl;
alter table ${iml_schema}.agt_wph_crdt_appl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_wph_crdt_appl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wph_crdt_appl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_wph_crdt_appl_icmsf1_tm purge;
drop table ${iml_schema}.agt_wph_crdt_appl_icmsf1_op purge;
drop table ${iml_schema}.agt_wph_crdt_appl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_wph_crdt_appl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wph_crdt_appl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
