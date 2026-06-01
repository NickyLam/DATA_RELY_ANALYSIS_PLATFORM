/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_lon_post_modif_appl_info_h_icmsf1
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
alter table ${iml_schema}.agt_lon_post_modif_appl_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_modif_appl_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,modif_flow_num -- 变更流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,new_loan_exp_dt -- 新贷款到期日期
    ,int_rat_modif_flg -- 利率变更标志
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_corp_cd -- 利率单位代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_flo_val -- 利率浮动值
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_mode_cd_two -- 利率模式代码二
    ,int_rat_corp_cd_two -- 利率单位代码二
    ,int_rat_adj_way_cd_two -- 利率调整方式代码二
    ,base_rat_type_cd_two -- 基准利率类型代码二
    ,int_rat_float_type_cd_two -- 利率浮动类型代码二
    ,int_rat_flo_val_two -- 利率浮动值二
    ,base_rat_two -- 基准利率二
    ,exec_int_rat_two -- 执行利率二
    ,distr_acct_id -- 放款账户编号
    ,repay_num -- 还款账号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_type_cd -- 还款周期类型代码
    ,deflt_repay_day -- 默认还款日
    ,spec_ped_cd -- 指定周期代码
    ,bal_pay_amt -- 尾款金额
    ,enter_acct_org_id -- 入账机构编号
    ,core_tran_flow_num -- 核心交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,effect_dt -- 生效日期
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,cmplt_flg -- 完成标志
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_day -- 原还款日
    ,repay_acct_name -- 还款账户名称
    ,init_repay_num_id -- 原还款账户编号
    ,init_repay_num_name -- 原还款账户名称
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lon_post_modif_appl_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_modif_appl_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_lon_post_modif_appl_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_afterloan_change-1
insert into ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,modif_flow_num -- 变更流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,new_loan_exp_dt -- 新贷款到期日期
    ,int_rat_modif_flg -- 利率变更标志
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_corp_cd -- 利率单位代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_flo_val -- 利率浮动值
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_mode_cd_two -- 利率模式代码二
    ,int_rat_corp_cd_two -- 利率单位代码二
    ,int_rat_adj_way_cd_two -- 利率调整方式代码二
    ,base_rat_type_cd_two -- 基准利率类型代码二
    ,int_rat_float_type_cd_two -- 利率浮动类型代码二
    ,int_rat_flo_val_two -- 利率浮动值二
    ,base_rat_two -- 基准利率二
    ,exec_int_rat_two -- 执行利率二
    ,distr_acct_id -- 放款账户编号
    ,repay_num -- 还款账号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_type_cd -- 还款周期类型代码
    ,deflt_repay_day -- 默认还款日
    ,spec_ped_cd -- 指定周期代码
    ,bal_pay_amt -- 尾款金额
    ,enter_acct_org_id -- 入账机构编号
    ,core_tran_flow_num -- 核心交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,effect_dt -- 生效日期
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,cmplt_flg -- 完成标志
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_day -- 原还款日
    ,repay_acct_name -- 还款账户名称
    ,init_repay_num_id -- 原还款账户编号
    ,init_repay_num_name -- 原还款账户名称
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300024'||SERIALNO -- 协议编号
    ,P1.SERIALNO -- 变更流水号
    ,nvl(trim(P1.TRANSCODE),'-') -- 交易类型代码
    ,P1.RELATIVESERIALNO -- 关联对象流水号
    ,P1.OBJECTTYPE -- 关联对象类型名称
    ,P1.LOANNO -- 关联借据编号
    ,nvl(trim(P1.APPLYSTATUS),'-') -- 申请状态代码
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.PRODUCTID -- 产品编号
    ,P1.OLDMATURITYDATE -- 原贷款到期日期
    ,P1.NEWMATURITYDATE -- 新贷款到期日期
    ,P1.RATECHANGEFLAG -- 利率变更标志
    ,nvl(trim(P1.TERMID),'-') -- 利率模式代码
    ,nvl(trim(P1.RATEUNIT),'-') -- 利率单位代码
    ,nvl(trim(P1.REPRICETYPE),'-') -- 利率调整方式代码
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动类型代码
    ,P1.RATEFLOAT -- 利率浮动值
    ,P1.BASERATE -- 基准利率
    ,P1.BUSINESSRATE -- 执行利率
    ,P1.TERMID2 -- 利率模式代码二
    ,nvl(trim(P1.RATEUNIT2),'-') -- 利率单位代码二
    ,nvl(trim(P1.REPRICETYPE2),'-') -- 利率调整方式代码二
    ,nvl(trim(P1.BASERATETYPE2),'-') -- 基准利率类型代码二
    ,nvl(trim(P1.RATEFLOATTYPE2),'-') -- 利率浮动类型代码二
    ,P1.RATEFLOAT2 -- 利率浮动值二
    ,P1.BASERATE2 -- 基准利率二
    ,P1.BUSINESSRATE2 -- 执行利率二
    ,P1.PUTOUTACCOUNT -- 放款账户编号
    ,P1.PAYMENTACCOUNT -- 还款账号
    ,nvl(trim(P1.PAYMENTTYPE),'-') -- 还款方式代码
    ,nvl(trim(P1.PAYFREQUENCYTYPE),'-') -- 还款周期类型代码
    ,P1.DEFAULTDUEDAY -- 默认还款日
    ,nvl(trim(P1.PAYFREQUENCY),'-') -- 指定周期代码
    ,P1.SEGRPTAMOUNT -- 尾款金额
    ,P1.ACCOUNTINGORGID -- 入账机构编号
    ,P1.TRANSNO -- 核心交易流水号
    ,nvl(trim(P1.TRANSSTATUS),'-') -- 交易状态代码
    ,P1.EXCUTEDATE -- 交易日期
    ,P1.TRANSDATE -- 生效日期
    ,P1.REMARK -- 备注
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 变更日期
    ,P1.COMPLETEFLAG -- 完成标志
    ,nvl(trim(P1.BELONGDEPT),'-') -- 所属条线代码
    ,'9999' -- 法人编号
    ,nvl(trim(P1.OLDREPAYTYPE),'-') -- 原还款方式代码
    ,P1.OLDREPAYDATE -- 原还款日
    ,P1.REPAYACCNAME -- 还款账户名称
    ,P1.OLDREPAYACCNO -- 原还款账户编号
    ,P1.OLDREPAYACCNAME -- 原还款账户名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_afterloan_change' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_afterloan_change p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,modif_flow_num
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
        into ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,modif_flow_num -- 变更流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,new_loan_exp_dt -- 新贷款到期日期
    ,int_rat_modif_flg -- 利率变更标志
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_corp_cd -- 利率单位代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_flo_val -- 利率浮动值
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_mode_cd_two -- 利率模式代码二
    ,int_rat_corp_cd_two -- 利率单位代码二
    ,int_rat_adj_way_cd_two -- 利率调整方式代码二
    ,base_rat_type_cd_two -- 基准利率类型代码二
    ,int_rat_float_type_cd_two -- 利率浮动类型代码二
    ,int_rat_flo_val_two -- 利率浮动值二
    ,base_rat_two -- 基准利率二
    ,exec_int_rat_two -- 执行利率二
    ,distr_acct_id -- 放款账户编号
    ,repay_num -- 还款账号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_type_cd -- 还款周期类型代码
    ,deflt_repay_day -- 默认还款日
    ,spec_ped_cd -- 指定周期代码
    ,bal_pay_amt -- 尾款金额
    ,enter_acct_org_id -- 入账机构编号
    ,core_tran_flow_num -- 核心交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,effect_dt -- 生效日期
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,cmplt_flg -- 完成标志
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_day -- 原还款日
    ,repay_acct_name -- 还款账户名称
    ,init_repay_num_id -- 原还款账户编号
    ,init_repay_num_name -- 原还款账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,modif_flow_num -- 变更流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,new_loan_exp_dt -- 新贷款到期日期
    ,int_rat_modif_flg -- 利率变更标志
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_corp_cd -- 利率单位代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_flo_val -- 利率浮动值
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_mode_cd_two -- 利率模式代码二
    ,int_rat_corp_cd_two -- 利率单位代码二
    ,int_rat_adj_way_cd_two -- 利率调整方式代码二
    ,base_rat_type_cd_two -- 基准利率类型代码二
    ,int_rat_float_type_cd_two -- 利率浮动类型代码二
    ,int_rat_flo_val_two -- 利率浮动值二
    ,base_rat_two -- 基准利率二
    ,exec_int_rat_two -- 执行利率二
    ,distr_acct_id -- 放款账户编号
    ,repay_num -- 还款账号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_type_cd -- 还款周期类型代码
    ,deflt_repay_day -- 默认还款日
    ,spec_ped_cd -- 指定周期代码
    ,bal_pay_amt -- 尾款金额
    ,enter_acct_org_id -- 入账机构编号
    ,core_tran_flow_num -- 核心交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,effect_dt -- 生效日期
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,cmplt_flg -- 完成标志
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_day -- 原还款日
    ,repay_acct_name -- 还款账户名称
    ,init_repay_num_id -- 原还款账户编号
    ,init_repay_num_name -- 原还款账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.modif_flow_num, o.modif_flow_num) as modif_flow_num -- 变更流水号
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.rela_obj_flow_num, o.rela_obj_flow_num) as rela_obj_flow_num -- 关联对象流水号
    ,nvl(n.rela_obj_type_name, o.rela_obj_type_name) as rela_obj_type_name -- 关联对象类型名称
    ,nvl(n.rela_dubil_id, o.rela_dubil_id) as rela_dubil_id -- 关联借据编号
    ,nvl(n.appl_status_cd, o.appl_status_cd) as appl_status_cd -- 申请状态代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.init_loan_exp_dt, o.init_loan_exp_dt) as init_loan_exp_dt -- 原贷款到期日期
    ,nvl(n.new_loan_exp_dt, o.new_loan_exp_dt) as new_loan_exp_dt -- 新贷款到期日期
    ,nvl(n.int_rat_modif_flg, o.int_rat_modif_flg) as int_rat_modif_flg -- 利率变更标志
    ,nvl(n.int_rat_mode_cd, o.int_rat_mode_cd) as int_rat_mode_cd -- 利率模式代码
    ,nvl(n.int_rat_corp_cd, o.int_rat_corp_cd) as int_rat_corp_cd -- 利率单位代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.int_rat_float_type_cd, o.int_rat_float_type_cd) as int_rat_float_type_cd -- 利率浮动类型代码
    ,nvl(n.int_rat_flo_val, o.int_rat_flo_val) as int_rat_flo_val -- 利率浮动值
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.int_rat_mode_cd_two, o.int_rat_mode_cd_two) as int_rat_mode_cd_two -- 利率模式代码二
    ,nvl(n.int_rat_corp_cd_two, o.int_rat_corp_cd_two) as int_rat_corp_cd_two -- 利率单位代码二
    ,nvl(n.int_rat_adj_way_cd_two, o.int_rat_adj_way_cd_two) as int_rat_adj_way_cd_two -- 利率调整方式代码二
    ,nvl(n.base_rat_type_cd_two, o.base_rat_type_cd_two) as base_rat_type_cd_two -- 基准利率类型代码二
    ,nvl(n.int_rat_float_type_cd_two, o.int_rat_float_type_cd_two) as int_rat_float_type_cd_two -- 利率浮动类型代码二
    ,nvl(n.int_rat_flo_val_two, o.int_rat_flo_val_two) as int_rat_flo_val_two -- 利率浮动值二
    ,nvl(n.base_rat_two, o.base_rat_two) as base_rat_two -- 基准利率二
    ,nvl(n.exec_int_rat_two, o.exec_int_rat_two) as exec_int_rat_two -- 执行利率二
    ,nvl(n.distr_acct_id, o.distr_acct_id) as distr_acct_id -- 放款账户编号
    ,nvl(n.repay_num, o.repay_num) as repay_num -- 还款账号
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_ped_type_cd, o.repay_ped_type_cd) as repay_ped_type_cd -- 还款周期类型代码
    ,nvl(n.deflt_repay_day, o.deflt_repay_day) as deflt_repay_day -- 默认还款日
    ,nvl(n.spec_ped_cd, o.spec_ped_cd) as spec_ped_cd -- 指定周期代码
    ,nvl(n.bal_pay_amt, o.bal_pay_amt) as bal_pay_amt -- 尾款金额
    ,nvl(n.enter_acct_org_id, o.enter_acct_org_id) as enter_acct_org_id -- 入账机构编号
    ,nvl(n.core_tran_flow_num, o.core_tran_flow_num) as core_tran_flow_num -- 核心交易流水号
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,nvl(n.cmplt_flg, o.cmplt_flg) as cmplt_flg -- 完成标志
    ,nvl(n.belong_strip_line_cd, o.belong_strip_line_cd) as belong_strip_line_cd -- 所属条线代码
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.init_repay_way_cd, o.init_repay_way_cd) as init_repay_way_cd -- 原还款方式代码
    ,nvl(n.init_repay_day, o.init_repay_day) as init_repay_day -- 原还款日
    ,nvl(n.repay_acct_name, o.repay_acct_name) as repay_acct_name -- 还款账户名称
    ,nvl(n.init_repay_num_id, o.init_repay_num_id) as init_repay_num_id -- 原还款账户编号
    ,nvl(n.init_repay_num_name, o.init_repay_num_name) as init_repay_num_name -- 原还款账户名称
    ,case when
            n.agt_id is null
            and n.modif_flow_num is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.modif_flow_num is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.modif_flow_num is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.modif_flow_num = n.modif_flow_num
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.modif_flow_num is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.modif_flow_num is null
        and n.lp_id is null
    )
    or (
        o.tran_type_cd <> n.tran_type_cd
        or o.rela_obj_flow_num <> n.rela_obj_flow_num
        or o.rela_obj_type_name <> n.rela_obj_type_name
        or o.rela_dubil_id <> n.rela_dubil_id
        or o.appl_status_cd <> n.appl_status_cd
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.prod_id <> n.prod_id
        or o.init_loan_exp_dt <> n.init_loan_exp_dt
        or o.new_loan_exp_dt <> n.new_loan_exp_dt
        or o.int_rat_modif_flg <> n.int_rat_modif_flg
        or o.int_rat_mode_cd <> n.int_rat_mode_cd
        or o.int_rat_corp_cd <> n.int_rat_corp_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.int_rat_float_type_cd <> n.int_rat_float_type_cd
        or o.int_rat_flo_val <> n.int_rat_flo_val
        or o.base_rat <> n.base_rat
        or o.exec_int_rat <> n.exec_int_rat
        or o.int_rat_mode_cd_two <> n.int_rat_mode_cd_two
        or o.int_rat_corp_cd_two <> n.int_rat_corp_cd_two
        or o.int_rat_adj_way_cd_two <> n.int_rat_adj_way_cd_two
        or o.base_rat_type_cd_two <> n.base_rat_type_cd_two
        or o.int_rat_float_type_cd_two <> n.int_rat_float_type_cd_two
        or o.int_rat_flo_val_two <> n.int_rat_flo_val_two
        or o.base_rat_two <> n.base_rat_two
        or o.exec_int_rat_two <> n.exec_int_rat_two
        or o.distr_acct_id <> n.distr_acct_id
        or o.repay_num <> n.repay_num
        or o.repay_way_cd <> n.repay_way_cd
        or o.repay_ped_type_cd <> n.repay_ped_type_cd
        or o.deflt_repay_day <> n.deflt_repay_day
        or o.spec_ped_cd <> n.spec_ped_cd
        or o.bal_pay_amt <> n.bal_pay_amt
        or o.enter_acct_org_id <> n.enter_acct_org_id
        or o.core_tran_flow_num <> n.core_tran_flow_num
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_dt <> n.tran_dt
        or o.effect_dt <> n.effect_dt
        or o.remark <> n.remark
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
        or o.cmplt_flg <> n.cmplt_flg
        or o.belong_strip_line_cd <> n.belong_strip_line_cd
        or o.init_repay_way_cd <> n.init_repay_way_cd
        or o.init_repay_day <> n.init_repay_day
        or o.repay_acct_name <> n.repay_acct_name
        or o.init_repay_num_id <> n.init_repay_num_id
        or o.init_repay_num_name <> n.init_repay_num_name
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,modif_flow_num -- 变更流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,new_loan_exp_dt -- 新贷款到期日期
    ,int_rat_modif_flg -- 利率变更标志
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_corp_cd -- 利率单位代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_flo_val -- 利率浮动值
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_mode_cd_two -- 利率模式代码二
    ,int_rat_corp_cd_two -- 利率单位代码二
    ,int_rat_adj_way_cd_two -- 利率调整方式代码二
    ,base_rat_type_cd_two -- 基准利率类型代码二
    ,int_rat_float_type_cd_two -- 利率浮动类型代码二
    ,int_rat_flo_val_two -- 利率浮动值二
    ,base_rat_two -- 基准利率二
    ,exec_int_rat_two -- 执行利率二
    ,distr_acct_id -- 放款账户编号
    ,repay_num -- 还款账号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_type_cd -- 还款周期类型代码
    ,deflt_repay_day -- 默认还款日
    ,spec_ped_cd -- 指定周期代码
    ,bal_pay_amt -- 尾款金额
    ,enter_acct_org_id -- 入账机构编号
    ,core_tran_flow_num -- 核心交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,effect_dt -- 生效日期
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,cmplt_flg -- 完成标志
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_day -- 原还款日
    ,repay_acct_name -- 还款账户名称
    ,init_repay_num_id -- 原还款账户编号
    ,init_repay_num_name -- 原还款账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,modif_flow_num -- 变更流水号
    ,tran_type_cd -- 交易类型代码
    ,rela_obj_flow_num -- 关联对象流水号
    ,rela_obj_type_name -- 关联对象类型名称
    ,rela_dubil_id -- 关联借据编号
    ,appl_status_cd -- 申请状态代码
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,new_loan_exp_dt -- 新贷款到期日期
    ,int_rat_modif_flg -- 利率变更标志
    ,int_rat_mode_cd -- 利率模式代码
    ,int_rat_corp_cd -- 利率单位代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,int_rat_flo_val -- 利率浮动值
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,int_rat_mode_cd_two -- 利率模式代码二
    ,int_rat_corp_cd_two -- 利率单位代码二
    ,int_rat_adj_way_cd_two -- 利率调整方式代码二
    ,base_rat_type_cd_two -- 基准利率类型代码二
    ,int_rat_float_type_cd_two -- 利率浮动类型代码二
    ,int_rat_flo_val_two -- 利率浮动值二
    ,base_rat_two -- 基准利率二
    ,exec_int_rat_two -- 执行利率二
    ,distr_acct_id -- 放款账户编号
    ,repay_num -- 还款账号
    ,repay_way_cd -- 还款方式代码
    ,repay_ped_type_cd -- 还款周期类型代码
    ,deflt_repay_day -- 默认还款日
    ,spec_ped_cd -- 指定周期代码
    ,bal_pay_amt -- 尾款金额
    ,enter_acct_org_id -- 入账机构编号
    ,core_tran_flow_num -- 核心交易流水号
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,effect_dt -- 生效日期
    ,remark -- 备注
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,cmplt_flg -- 完成标志
    ,belong_strip_line_cd -- 所属条线代码
    ,lp_id -- 法人编号
    ,init_repay_way_cd -- 原还款方式代码
    ,init_repay_day -- 原还款日
    ,repay_acct_name -- 还款账户名称
    ,init_repay_num_id -- 原还款账户编号
    ,init_repay_num_name -- 原还款账户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.modif_flow_num -- 变更流水号
    ,o.tran_type_cd -- 交易类型代码
    ,o.rela_obj_flow_num -- 关联对象流水号
    ,o.rela_obj_type_name -- 关联对象类型名称
    ,o.rela_dubil_id -- 关联借据编号
    ,o.appl_status_cd -- 申请状态代码
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.prod_id -- 产品编号
    ,o.init_loan_exp_dt -- 原贷款到期日期
    ,o.new_loan_exp_dt -- 新贷款到期日期
    ,o.int_rat_modif_flg -- 利率变更标志
    ,o.int_rat_mode_cd -- 利率模式代码
    ,o.int_rat_corp_cd -- 利率单位代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.int_rat_float_type_cd -- 利率浮动类型代码
    ,o.int_rat_flo_val -- 利率浮动值
    ,o.base_rat -- 基准利率
    ,o.exec_int_rat -- 执行利率
    ,o.int_rat_mode_cd_two -- 利率模式代码二
    ,o.int_rat_corp_cd_two -- 利率单位代码二
    ,o.int_rat_adj_way_cd_two -- 利率调整方式代码二
    ,o.base_rat_type_cd_two -- 基准利率类型代码二
    ,o.int_rat_float_type_cd_two -- 利率浮动类型代码二
    ,o.int_rat_flo_val_two -- 利率浮动值二
    ,o.base_rat_two -- 基准利率二
    ,o.exec_int_rat_two -- 执行利率二
    ,o.distr_acct_id -- 放款账户编号
    ,o.repay_num -- 还款账号
    ,o.repay_way_cd -- 还款方式代码
    ,o.repay_ped_type_cd -- 还款周期类型代码
    ,o.deflt_repay_day -- 默认还款日
    ,o.spec_ped_cd -- 指定周期代码
    ,o.bal_pay_amt -- 尾款金额
    ,o.enter_acct_org_id -- 入账机构编号
    ,o.core_tran_flow_num -- 核心交易流水号
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_dt -- 交易日期
    ,o.effect_dt -- 生效日期
    ,o.remark -- 备注
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.cmplt_flg -- 完成标志
    ,o.belong_strip_line_cd -- 所属条线代码
    ,o.lp_id -- 法人编号
    ,o.init_repay_way_cd -- 原还款方式代码
    ,o.init_repay_day -- 原还款日
    ,o.repay_acct_name -- 还款账户名称
    ,o.init_repay_num_id -- 原还款账户编号
    ,o.init_repay_num_name -- 原还款账户名称
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
from ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.modif_flow_num = n.modif_flow_num
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.modif_flow_num = d.modif_flow_num
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_lon_post_modif_appl_info_h;
--alter table ${iml_schema}.agt_lon_post_modif_appl_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_lon_post_modif_appl_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_lon_post_modif_appl_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_lon_post_modif_appl_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_lon_post_modif_appl_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_lon_post_modif_appl_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_lon_post_modif_appl_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_lon_post_modif_appl_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_lon_post_modif_appl_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
