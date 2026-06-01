/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_crdt_bus_info_h_icmsf1
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
alter table ${iml_schema}.agt_crdt_bus_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_bus_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,prod_id -- 产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_bus_id -- 最初来源业务编号
    ,happ_way_cd -- 发生方式代码
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,guar_way_cd -- 担保方式代码
    ,circl_flg -- 可循环标志
    ,amt_convt_coef -- 金额折算系数
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,status_cd -- 状态代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,margin_amt -- 保证金金额
    ,pm_rat -- 抵质押率
    ,float_int_rat -- 浮动利率
    ,bal_update_tm -- 余额更新时间
    ,actl_ocup_pre_ocup_nmal_amt -- 实际占用预占名义金额
    ,actl_ocup_pre_ocup_open_amt -- 实际占用预占敞口金额
    ,pre_ocup_id -- 预占编号
    ,low_risk_bus_flg -- 低风险业务标志
    ,pmo_amt -- 抵质押物金额
    ,bus_cont_type_cd -- 业务合同类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_bus_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_bus_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_crdt_bus_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_cl_business_info-1
insert into ${iml_schema}.agt_crdt_bus_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,prod_id -- 产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_bus_id -- 最初来源业务编号
    ,happ_way_cd -- 发生方式代码
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,guar_way_cd -- 担保方式代码
    ,circl_flg -- 可循环标志
    ,amt_convt_coef -- 金额折算系数
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,status_cd -- 状态代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,margin_amt -- 保证金金额
    ,pm_rat -- 抵质押率
    ,float_int_rat -- 浮动利率
    ,bal_update_tm -- 余额更新时间
    ,actl_ocup_pre_ocup_nmal_amt -- 实际占用预占名义金额
    ,actl_ocup_pre_ocup_open_amt -- 实际占用预占敞口金额
    ,pre_ocup_id -- 预占编号
    ,low_risk_bus_flg -- 低风险业务标志
    ,pmo_amt -- 抵质押物金额
    ,bus_cont_type_cd -- 业务合同类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300007'||P1.BUSINESSNO -- 协议编号
    ,P1.BUSINESSNO -- 业务编号
    ,P1.BUSINESSTYPE -- 产品编号
    ,nvl(trim(P1.CREDITPHASE),'-') -- 当前授信阶段代码
    ,nvl(trim(P1.SOURCESYSTEM),'-') -- 最初来源系统代码
    ,P1.SOURCEBUSINESSNO -- 最初来源业务编号
    ,NVL(TRIM(P1.OCCURWAY),'-') -- 发生方式代码
    ,P1.CUSTOMERID -- 客户编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,P1.EXPOSUREAMOUNT -- 敞口金额
    ,P1.NOMINALAMOUNT -- 名义金额
    ,P1.EXECNOMINALAMOUNT -- 执行名义金额
    ,P1.EXECEXPOSUREAMOUNT -- 执行敞口金额
    ,P1.AVAILABLENOMINALAMOUNT -- 可用名义金额
    ,P1.AVAILABLEEXPOSUREAMOUNT -- 可用敞口金额
    ,P1.NOMINALBALANCE -- 授信名义余额
    ,P1.EXPOSUREBALANCE -- 授信敞口余额
    ,P1.EXECSLOWRELEASEEXPOSUREAMOUNT -- 执行可缓释敞口金额
    ,nvl(trim(P1.SLOWRELEASEEXPOSURECURRENCY),'-') -- 可缓释敞口币种代码
    ,P1.SLOWRELEASEEXPOSUREAMOUNT -- 可缓释敞口金额
    ,nvl(trim(P1.GUARANTYWAY),'-') -- 担保方式代码
    ,nvl(trim(P1.RECYCLABLE),'-') -- 可循环标志
    ,P1.AMOUNTFACTOR -- 金额折算系数
    ,decode(p1.EFFECTIVEDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.EFFECTIVEDATE) -- 生效日期
    ,decode(p1.EXPIREDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.EXPIREDATE) -- 到期日期
    ,nvl(trim(P1.OCCUPYFLAG),'-') -- 占用标识代码
    ,NVL(trim(P1.STATUS),'-') -- 状态代码
    ,P1.TIMELIMITDAY -- 日期限
    ,P1.TIMELIMITMONTH -- 月期限
    ,P1.TOTALPAYMENT -- 累计放款金额
    ,P1.TOTALREPAYMENT -- 累计还款金额
    ,decode(p1.ACTUALEXPIREDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.ACTUALEXPIREDATE) -- 实际失效日期
    ,P1.OPERATEUSERID -- 业务经办人编号
    ,P1.OPERATEORGID -- 经办机构编号
    ,P1.MANAGEUSERID -- 管理柜员编号
    ,P1.MANAGEORGID -- 管理机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,decode(p1.INPUTDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.INPUTDATE) -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,decode(p1.UPDATEDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.UPDATEDATE) -- 变更日期
    ,P1.SECURITYDEPOSIT -- 保证金金额
    ,P1.PLEDGERATE -- 抵质押率
    ,P1.FLOATINGRATE -- 浮动利率
    ,decode(P1.BALANCEUPDATETIME,to_timestamp('0001-01-01','yyyy-mm-dd hh24:mi:ss.ff8'),to_timestamp('2999-12-31','yyyy-mm-dd hh24:mi:ss.ff8'),P1.BALANCEUPDATETIME) -- 余额更新时间
    ,P1.ACTUALPRENOMAMOUNT -- 实际占用预占名义金额
    ,P1.ACTUALPREEXPAMOUNT -- 实际占用预占敞口金额
    ,P1.PRENO -- 预占编号
    ,decode(P1.ISLOWRISK,' ','-','Y','1','N','0',P1.ISLOWRISK) -- 低风险业务标志
    ,P1.PLEDGESUM -- 抵质押物金额
    ,decode(P1.BCTYPE,' ','00','1','01','2','02',P1.BCTYPE) -- 业务合同类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_cl_business_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_cl_business_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_crdt_bus_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,bus_id
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
        into ${iml_schema}.agt_crdt_bus_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,prod_id -- 产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_bus_id -- 最初来源业务编号
    ,happ_way_cd -- 发生方式代码
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,guar_way_cd -- 担保方式代码
    ,circl_flg -- 可循环标志
    ,amt_convt_coef -- 金额折算系数
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,status_cd -- 状态代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,margin_amt -- 保证金金额
    ,pm_rat -- 抵质押率
    ,float_int_rat -- 浮动利率
    ,bal_update_tm -- 余额更新时间
    ,actl_ocup_pre_ocup_nmal_amt -- 实际占用预占名义金额
    ,actl_ocup_pre_ocup_open_amt -- 实际占用预占敞口金额
    ,pre_ocup_id -- 预占编号
    ,low_risk_bus_flg -- 低风险业务标志
    ,pmo_amt -- 抵质押物金额
    ,bus_cont_type_cd -- 业务合同类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_crdt_bus_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,prod_id -- 产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_bus_id -- 最初来源业务编号
    ,happ_way_cd -- 发生方式代码
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,guar_way_cd -- 担保方式代码
    ,circl_flg -- 可循环标志
    ,amt_convt_coef -- 金额折算系数
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,status_cd -- 状态代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,margin_amt -- 保证金金额
    ,pm_rat -- 抵质押率
    ,float_int_rat -- 浮动利率
    ,bal_update_tm -- 余额更新时间
    ,actl_ocup_pre_ocup_nmal_amt -- 实际占用预占名义金额
    ,actl_ocup_pre_ocup_open_amt -- 实际占用预占敞口金额
    ,pre_ocup_id -- 预占编号
    ,low_risk_bus_flg -- 低风险业务标志
    ,pmo_amt -- 抵质押物金额
    ,bus_cont_type_cd -- 业务合同类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 业务编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.curr_crdt_stage_cd, o.curr_crdt_stage_cd) as curr_crdt_stage_cd -- 当前授信阶段代码
    ,nvl(n.init_src_sys_cd, o.init_src_sys_cd) as init_src_sys_cd -- 最初来源系统代码
    ,nvl(n.init_src_bus_id, o.init_src_bus_id) as init_src_bus_id -- 最初来源业务编号
    ,nvl(n.happ_way_cd, o.happ_way_cd) as happ_way_cd -- 发生方式代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.open_amt, o.open_amt) as open_amt -- 敞口金额
    ,nvl(n.nmal_amt, o.nmal_amt) as nmal_amt -- 名义金额
    ,nvl(n.exec_nmal_amt, o.exec_nmal_amt) as exec_nmal_amt -- 执行名义金额
    ,nvl(n.exec_open_amt, o.exec_open_amt) as exec_open_amt -- 执行敞口金额
    ,nvl(n.aval_nmal_amt, o.aval_nmal_amt) as aval_nmal_amt -- 可用名义金额
    ,nvl(n.aval_open_amt, o.aval_open_amt) as aval_open_amt -- 可用敞口金额
    ,nvl(n.crdt_nmal_bal, o.crdt_nmal_bal) as crdt_nmal_bal -- 授信名义余额
    ,nvl(n.crdt_open_bal, o.crdt_open_bal) as crdt_open_bal -- 授信敞口余额
    ,nvl(n.exec_dr_open_amt, o.exec_dr_open_amt) as exec_dr_open_amt -- 执行可缓释敞口金额
    ,nvl(n.dr_open_curr_cd, o.dr_open_curr_cd) as dr_open_curr_cd -- 可缓释敞口币种代码
    ,nvl(n.dr_open_amt, o.dr_open_amt) as dr_open_amt -- 可缓释敞口金额
    ,nvl(n.guar_way_cd, o.guar_way_cd) as guar_way_cd -- 担保方式代码
    ,nvl(n.circl_flg, o.circl_flg) as circl_flg -- 可循环标志
    ,nvl(n.amt_convt_coef, o.amt_convt_coef) as amt_convt_coef -- 金额折算系数
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.ocup_idf_cd, o.ocup_idf_cd) as ocup_idf_cd -- 占用标识代码
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.day_tenor, o.day_tenor) as day_tenor -- 日期限
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.acm_distr_amt, o.acm_distr_amt) as acm_distr_amt -- 累计放款金额
    ,nvl(n.acm_repay_amt, o.acm_repay_amt) as acm_repay_amt -- 累计还款金额
    ,nvl(n.actl_invalid_dt, o.actl_invalid_dt) as actl_invalid_dt -- 实际失效日期
    ,nvl(n.oper_teller_id, o.oper_teller_id) as oper_teller_id -- 业务经办人编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.mgmt_teller_id, o.mgmt_teller_id) as mgmt_teller_id -- 管理柜员编号
    ,nvl(n.mgmt_org_id, o.mgmt_org_id) as mgmt_org_id -- 管理机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.margin_amt, o.margin_amt) as margin_amt -- 保证金金额
    ,nvl(n.pm_rat, o.pm_rat) as pm_rat -- 抵质押率
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.bal_update_tm, o.bal_update_tm) as bal_update_tm -- 余额更新时间
    ,nvl(n.actl_ocup_pre_ocup_nmal_amt, o.actl_ocup_pre_ocup_nmal_amt) as actl_ocup_pre_ocup_nmal_amt -- 实际占用预占名义金额
    ,nvl(n.actl_ocup_pre_ocup_open_amt, o.actl_ocup_pre_ocup_open_amt) as actl_ocup_pre_ocup_open_amt -- 实际占用预占敞口金额
    ,nvl(n.pre_ocup_id, o.pre_ocup_id) as pre_ocup_id -- 预占编号
    ,nvl(n.low_risk_bus_flg, o.low_risk_bus_flg) as low_risk_bus_flg -- 低风险业务标志
    ,nvl(n.pmo_amt, o.pmo_amt) as pmo_amt -- 抵质押物金额
    ,nvl(n.bus_cont_type_cd, o.bus_cont_type_cd) as bus_cont_type_cd -- 业务合同类型代码
    ,case when
            n.agt_id is null
            and n.bus_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.bus_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.bus_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_crdt_bus_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_crdt_bus_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.bus_id = n.bus_id
where (
        o.agt_id is null
        and o.bus_id is null
    )
    or (
        n.agt_id is null
        and n.bus_id is null
    )
    or (
        o.prod_id <> n.prod_id
        or o.curr_crdt_stage_cd <> n.curr_crdt_stage_cd
        or o.init_src_sys_cd <> n.init_src_sys_cd
        or o.init_src_bus_id <> n.init_src_bus_id
        or o.happ_way_cd <> n.happ_way_cd
        or o.cust_id <> n.cust_id
        or o.curr_cd <> n.curr_cd
        or o.open_amt <> n.open_amt
        or o.nmal_amt <> n.nmal_amt
        or o.exec_nmal_amt <> n.exec_nmal_amt
        or o.exec_open_amt <> n.exec_open_amt
        or o.aval_nmal_amt <> n.aval_nmal_amt
        or o.aval_open_amt <> n.aval_open_amt
        or o.crdt_nmal_bal <> n.crdt_nmal_bal
        or o.crdt_open_bal <> n.crdt_open_bal
        or o.exec_dr_open_amt <> n.exec_dr_open_amt
        or o.dr_open_curr_cd <> n.dr_open_curr_cd
        or o.dr_open_amt <> n.dr_open_amt
        or o.guar_way_cd <> n.guar_way_cd
        or o.circl_flg <> n.circl_flg
        or o.amt_convt_coef <> n.amt_convt_coef
        or o.effect_dt <> n.effect_dt
        or o.exp_dt <> n.exp_dt
        or o.ocup_idf_cd <> n.ocup_idf_cd
        or o.status_cd <> n.status_cd
        or o.day_tenor <> n.day_tenor
        or o.mon_tenor <> n.mon_tenor
        or o.acm_distr_amt <> n.acm_distr_amt
        or o.acm_repay_amt <> n.acm_repay_amt
        or o.actl_invalid_dt <> n.actl_invalid_dt
        or o.oper_teller_id <> n.oper_teller_id
        or o.oper_org_id <> n.oper_org_id
        or o.mgmt_teller_id <> n.mgmt_teller_id
        or o.mgmt_org_id <> n.mgmt_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.margin_amt <> n.margin_amt
        or o.pm_rat <> n.pm_rat
        or o.float_int_rat <> n.float_int_rat
        or o.bal_update_tm <> n.bal_update_tm
        or o.actl_ocup_pre_ocup_nmal_amt <> n.actl_ocup_pre_ocup_nmal_amt
        or o.actl_ocup_pre_ocup_open_amt <> n.actl_ocup_pre_ocup_open_amt
        or o.pre_ocup_id <> n.pre_ocup_id
        or o.low_risk_bus_flg <> n.low_risk_bus_flg
        or o.pmo_amt <> n.pmo_amt
        or o.bus_cont_type_cd <> n.bus_cont_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_crdt_bus_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,prod_id -- 产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_bus_id -- 最初来源业务编号
    ,happ_way_cd -- 发生方式代码
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,guar_way_cd -- 担保方式代码
    ,circl_flg -- 可循环标志
    ,amt_convt_coef -- 金额折算系数
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,status_cd -- 状态代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,margin_amt -- 保证金金额
    ,pm_rat -- 抵质押率
    ,float_int_rat -- 浮动利率
    ,bal_update_tm -- 余额更新时间
    ,actl_ocup_pre_ocup_nmal_amt -- 实际占用预占名义金额
    ,actl_ocup_pre_ocup_open_amt -- 实际占用预占敞口金额
    ,pre_ocup_id -- 预占编号
    ,low_risk_bus_flg -- 低风险业务标志
    ,pmo_amt -- 抵质押物金额
    ,bus_cont_type_cd -- 业务合同类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_crdt_bus_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,bus_id -- 业务编号
    ,prod_id -- 产品编号
    ,curr_crdt_stage_cd -- 当前授信阶段代码
    ,init_src_sys_cd -- 最初来源系统代码
    ,init_src_bus_id -- 最初来源业务编号
    ,happ_way_cd -- 发生方式代码
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,open_amt -- 敞口金额
    ,nmal_amt -- 名义金额
    ,exec_nmal_amt -- 执行名义金额
    ,exec_open_amt -- 执行敞口金额
    ,aval_nmal_amt -- 可用名义金额
    ,aval_open_amt -- 可用敞口金额
    ,crdt_nmal_bal -- 授信名义余额
    ,crdt_open_bal -- 授信敞口余额
    ,exec_dr_open_amt -- 执行可缓释敞口金额
    ,dr_open_curr_cd -- 可缓释敞口币种代码
    ,dr_open_amt -- 可缓释敞口金额
    ,guar_way_cd -- 担保方式代码
    ,circl_flg -- 可循环标志
    ,amt_convt_coef -- 金额折算系数
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,ocup_idf_cd -- 占用标识代码
    ,status_cd -- 状态代码
    ,day_tenor -- 日期限
    ,mon_tenor -- 月期限
    ,acm_distr_amt -- 累计放款金额
    ,acm_repay_amt -- 累计还款金额
    ,actl_invalid_dt -- 实际失效日期
    ,oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,mgmt_teller_id -- 管理柜员编号
    ,mgmt_org_id -- 管理机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,margin_amt -- 保证金金额
    ,pm_rat -- 抵质押率
    ,float_int_rat -- 浮动利率
    ,bal_update_tm -- 余额更新时间
    ,actl_ocup_pre_ocup_nmal_amt -- 实际占用预占名义金额
    ,actl_ocup_pre_ocup_open_amt -- 实际占用预占敞口金额
    ,pre_ocup_id -- 预占编号
    ,low_risk_bus_flg -- 低风险业务标志
    ,pmo_amt -- 抵质押物金额
    ,bus_cont_type_cd -- 业务合同类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.bus_id -- 业务编号
    ,o.prod_id -- 产品编号
    ,o.curr_crdt_stage_cd -- 当前授信阶段代码
    ,o.init_src_sys_cd -- 最初来源系统代码
    ,o.init_src_bus_id -- 最初来源业务编号
    ,o.happ_way_cd -- 发生方式代码
    ,o.cust_id -- 客户编号
    ,o.curr_cd -- 币种代码
    ,o.open_amt -- 敞口金额
    ,o.nmal_amt -- 名义金额
    ,o.exec_nmal_amt -- 执行名义金额
    ,o.exec_open_amt -- 执行敞口金额
    ,o.aval_nmal_amt -- 可用名义金额
    ,o.aval_open_amt -- 可用敞口金额
    ,o.crdt_nmal_bal -- 授信名义余额
    ,o.crdt_open_bal -- 授信敞口余额
    ,o.exec_dr_open_amt -- 执行可缓释敞口金额
    ,o.dr_open_curr_cd -- 可缓释敞口币种代码
    ,o.dr_open_amt -- 可缓释敞口金额
    ,o.guar_way_cd -- 担保方式代码
    ,o.circl_flg -- 可循环标志
    ,o.amt_convt_coef -- 金额折算系数
    ,o.effect_dt -- 生效日期
    ,o.exp_dt -- 到期日期
    ,o.ocup_idf_cd -- 占用标识代码
    ,o.status_cd -- 状态代码
    ,o.day_tenor -- 日期限
    ,o.mon_tenor -- 月期限
    ,o.acm_distr_amt -- 累计放款金额
    ,o.acm_repay_amt -- 累计还款金额
    ,o.actl_invalid_dt -- 实际失效日期
    ,o.oper_teller_id -- 业务经办人编号
    ,o.oper_org_id -- 经办机构编号
    ,o.mgmt_teller_id -- 管理柜员编号
    ,o.mgmt_org_id -- 管理机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.margin_amt -- 保证金金额
    ,o.pm_rat -- 抵质押率
    ,o.float_int_rat -- 浮动利率
    ,o.bal_update_tm -- 余额更新时间
    ,o.actl_ocup_pre_ocup_nmal_amt -- 实际占用预占名义金额
    ,o.actl_ocup_pre_ocup_open_amt -- 实际占用预占敞口金额
    ,o.pre_ocup_id -- 预占编号
    ,o.low_risk_bus_flg -- 低风险业务标志
    ,o.pmo_amt -- 抵质押物金额
    ,o.bus_cont_type_cd -- 业务合同类型代码
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
from ${iml_schema}.agt_crdt_bus_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_crdt_bus_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.bus_id = n.bus_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_crdt_bus_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.bus_id = d.bus_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_crdt_bus_info_h;
--alter table ${iml_schema}.agt_crdt_bus_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_crdt_bus_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_crdt_bus_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_crdt_bus_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_crdt_bus_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_crdt_bus_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_crdt_bus_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_crdt_bus_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_crdt_bus_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
