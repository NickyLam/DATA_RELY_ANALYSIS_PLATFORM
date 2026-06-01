/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_margin_unfrz_appl_icmsf1
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
alter table ${iml_schema}.evt_margin_unfrz_appl add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_margin_unfrz_appl partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_tm purge;
drop table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_op purge;
drop table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,margin_acct_id -- 保证金账户编号
    ,margin_acct_attr_cd -- 保证金账户属性代码
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,margin_acct_bal -- 保证金账户余额
    ,agt_rat -- 协议利率
    ,dep_base_rat -- 存款基准利率
    ,dep_term -- 存期
    ,tran_out_prod_id -- 转出产品编号
    ,tran_in_init_acct_flg -- 转入原账户标志
    ,margin_tran_in_acct_id -- 保证金转入账户编号
    ,margin_type_cd -- 保证金类型代码
    ,bill_id -- 票据编号
    ,bill_exp_dt -- 票据到期日期
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_exec_int_rat -- 保证金执行利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,flo_val -- 浮动值
    ,aldy_pay_margin_amt -- 已缴保证金金额
    ,sub_acct_num_froz_flow_num -- 子账号冻结流水号
    ,out_acct_flow_num -- 出账流水号
    ,froz_stop_pay_way_cd -- 冻结止付方式代码
    ,froz_stop_pay_type_cd -- 冻结止付类型代码
    ,froz_stop_pay_rs -- 冻结止付原因
    ,off_bs_acct_id -- 表外账户编号
    ,off_bs_acct_name -- 表外账户名称
    ,off_bs_entry_dir_cd -- 表外记账方向代码
    ,off_bs_memo -- 表外摘要
    ,int_accr_way_cd -- 计息方式代码
    ,init_agt_type_cd -- 原协议类型代码
    ,init_agt_id -- 原协议编号
    ,cont_flow_num -- 合同流水号
    ,bus_begin_dt -- 业务起始日期
    ,bus_exp_dt -- 业务到期日期
    ,bus_amt -- 业务金额
    ,bus_bal -- 业务余额
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,flow_status_cd -- 流程状态代码
    ,create_src_cd -- 生成来源代码
    ,curr_brwer_flg -- 当前借款人标志
    ,rels_open_flg -- 释放敞口标志
    ,aldy_revo_flg -- 已撤销标志
    ,batch_flow_num -- 批次流水号
    ,init_tran_flow_num -- 原交易流水号
    ,init_tran_dt -- 原交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,supp_comnt -- 追加说明
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_margin_unfrz_appl partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_margin_unfrz_appl partition for ('icmsf1') where 0=1;

create table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_margin_unfrz_appl partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_deposit_apply_info-1
insert into ${iml_schema}.evt_margin_unfrz_appl_icmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,margin_acct_id -- 保证金账户编号
    ,margin_acct_attr_cd -- 保证金账户属性代码
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,margin_acct_bal -- 保证金账户余额
    ,agt_rat -- 协议利率
    ,dep_base_rat -- 存款基准利率
    ,dep_term -- 存期
    ,tran_out_prod_id -- 转出产品编号
    ,tran_in_init_acct_flg -- 转入原账户标志
    ,margin_tran_in_acct_id -- 保证金转入账户编号
    ,margin_type_cd -- 保证金类型代码
    ,bill_id -- 票据编号
    ,bill_exp_dt -- 票据到期日期
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_exec_int_rat -- 保证金执行利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,flo_val -- 浮动值
    ,aldy_pay_margin_amt -- 已缴保证金金额
    ,sub_acct_num_froz_flow_num -- 子账号冻结流水号
    ,out_acct_flow_num -- 出账流水号
    ,froz_stop_pay_way_cd -- 冻结止付方式代码
    ,froz_stop_pay_type_cd -- 冻结止付类型代码
    ,froz_stop_pay_rs -- 冻结止付原因
    ,off_bs_acct_id -- 表外账户编号
    ,off_bs_acct_name -- 表外账户名称
    ,off_bs_entry_dir_cd -- 表外记账方向代码
    ,off_bs_memo -- 表外摘要
    ,int_accr_way_cd -- 计息方式代码
    ,init_agt_type_cd -- 原协议类型代码
    ,init_agt_id -- 原协议编号
    ,cont_flow_num -- 合同流水号
    ,bus_begin_dt -- 业务起始日期
    ,bus_exp_dt -- 业务到期日期
    ,bus_amt -- 业务金额
    ,bus_bal -- 业务余额
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,flow_status_cd -- 流程状态代码
    ,create_src_cd -- 生成来源代码
    ,curr_brwer_flg -- 当前借款人标志
    ,rels_open_flg -- 释放敞口标志
    ,aldy_revo_flg -- 已撤销标志
    ,batch_flow_num -- 批次流水号
    ,init_tran_flow_num -- 原交易流水号
    ,init_tran_dt -- 原交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,supp_comnt -- 追加说明
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '206007'||P1.SERIALNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 申请流水号
    ,P1.CUSID -- 客户编号
    ,P1.CUSNAME -- 客户名称
    ,P1.GRTEAC -- 保证金账户编号
    ,nvl(trim(P1.BAILINTERESTMETHOD),'-') -- 保证金账户属性代码
    ,P1.SUBACCOUNT -- 子账号
    ,nvl(trim(P1.CRCYCD),'-') -- 币种代码
    ,P1.BAILBALANCEAMT -- 保证金账户余额
    ,P1.INTERESTRATE -- 协议利率
    ,P1.DEPOSITBASERATE -- 存款基准利率
    ,P1.TERMCD -- 存期
    ,P1.BUSINESSTYPE -- 转出产品编号
    ,nvl(trim(P1.OPERTP),'-') -- 转入原账户标志
    ,P1.ACCTNO -- 保证金转入账户编号
    ,nvl(trim(P1.GRTETP),'-') -- 保证金类型代码
    ,P1.ACPTNO -- 票据编号
    ,P1.MATUDT -- 票据到期日期
    ,nvl(trim(P1.BAILTERM),'-') -- 保证金利率档次代码
    ,P1.BAILINTERESTRATE -- 保证金执行利率
    ,nvl(trim(P1.FXFLTP),'-') -- 保证金利率类型代码
    ,decode(P1.PDRIFM,' ','-','1','2','2','1',P1.PDRIFM) -- 利率浮动方式代码
    ,nvl(trim(P1.PDRIFD),'-') -- 利率浮动类型代码
    ,P1.PDRIFV -- 浮动值
    ,P1.BAILSUM -- 已缴保证金金额
    ,P1.OTFROZSQ -- 子账号冻结流水号
    ,P1.PUTOUTNO -- 出账流水号
    ,P1.OTSUSBTP -- 冻结止付方式代码
    ,P1.OTFRSPTP -- 冻结止付类型代码
    ,P1.OTFZREMK -- 冻结止付原因
    ,P1.OTRVACNO -- 表外账户编号
    ,P1.OTRVACNA -- 表外账户名称
    ,P1.OTRVBLDN -- 表外记账方向代码
    ,P1.PRCSNA -- 表外摘要
    ,nvl(trim(P1.INTERESTMETHOD),'-') -- 计息方式代码
    ,nvl(trim(P1.CNTRTP),'-') -- 原协议类型代码
    ,P1.DATAID -- 原协议编号
    ,P1.CONTRACTNO -- 合同流水号
    ,P1.PUTOUTDATE -- 业务起始日期
    ,P1.MATURITY -- 业务到期日期
    ,P1.BUSINESSSUM -- 业务金额
    ,P1.BALANCE -- 业务余额
    ,P1.EXCHANGESERIALNO -- 交易流水号
    ,P1.EXCHANGEDATE -- 交易日期
    ,P1.TRANAM -- 交易金额
    ,nvl(trim(P1.EXCHANGESTATE),'-') -- 交易状态代码
    ,nvl(trim(P1.APPROVESTATUS),'-') -- 流程状态代码
    ,nvl(trim(P1.INPUTTYPE),'-') -- 生成来源代码
    ,nvl(trim(P1.ISDISCOUNTFLAG),'-') -- 当前借款人标志
    ,nvl(trim(P1.ISOPEN),'-') -- 释放敞口标志
    ,decode(P1.HASCANCEL,' ','-','Y','1','N','0',P1.HASCANCEL) -- 已撤销标志
    ,P1.BATCHSERIALNO -- 批次流水号
    ,P1.INITEXCHANGESERIALNO -- 原交易流水号
    ,P1.INITEXCHANGEDATE -- 原交易日期
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,P1.UPDATEDATE -- 最后更新日期
    ,P1.REMAKE -- 追加说明
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_deposit_apply_info' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_deposit_apply_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_margin_unfrz_appl_icmsf1_tm 
  	                                group by 
  	                                        evt_id
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
        into ${iml_schema}.evt_margin_unfrz_appl_icmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,margin_acct_id -- 保证金账户编号
    ,margin_acct_attr_cd -- 保证金账户属性代码
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,margin_acct_bal -- 保证金账户余额
    ,agt_rat -- 协议利率
    ,dep_base_rat -- 存款基准利率
    ,dep_term -- 存期
    ,tran_out_prod_id -- 转出产品编号
    ,tran_in_init_acct_flg -- 转入原账户标志
    ,margin_tran_in_acct_id -- 保证金转入账户编号
    ,margin_type_cd -- 保证金类型代码
    ,bill_id -- 票据编号
    ,bill_exp_dt -- 票据到期日期
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_exec_int_rat -- 保证金执行利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,flo_val -- 浮动值
    ,aldy_pay_margin_amt -- 已缴保证金金额
    ,sub_acct_num_froz_flow_num -- 子账号冻结流水号
    ,out_acct_flow_num -- 出账流水号
    ,froz_stop_pay_way_cd -- 冻结止付方式代码
    ,froz_stop_pay_type_cd -- 冻结止付类型代码
    ,froz_stop_pay_rs -- 冻结止付原因
    ,off_bs_acct_id -- 表外账户编号
    ,off_bs_acct_name -- 表外账户名称
    ,off_bs_entry_dir_cd -- 表外记账方向代码
    ,off_bs_memo -- 表外摘要
    ,int_accr_way_cd -- 计息方式代码
    ,init_agt_type_cd -- 原协议类型代码
    ,init_agt_id -- 原协议编号
    ,cont_flow_num -- 合同流水号
    ,bus_begin_dt -- 业务起始日期
    ,bus_exp_dt -- 业务到期日期
    ,bus_amt -- 业务金额
    ,bus_bal -- 业务余额
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,flow_status_cd -- 流程状态代码
    ,create_src_cd -- 生成来源代码
    ,curr_brwer_flg -- 当前借款人标志
    ,rels_open_flg -- 释放敞口标志
    ,aldy_revo_flg -- 已撤销标志
    ,batch_flow_num -- 批次流水号
    ,init_tran_flow_num -- 原交易流水号
    ,init_tran_dt -- 原交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,supp_comnt -- 追加说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_margin_unfrz_appl_icmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,margin_acct_id -- 保证金账户编号
    ,margin_acct_attr_cd -- 保证金账户属性代码
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,margin_acct_bal -- 保证金账户余额
    ,agt_rat -- 协议利率
    ,dep_base_rat -- 存款基准利率
    ,dep_term -- 存期
    ,tran_out_prod_id -- 转出产品编号
    ,tran_in_init_acct_flg -- 转入原账户标志
    ,margin_tran_in_acct_id -- 保证金转入账户编号
    ,margin_type_cd -- 保证金类型代码
    ,bill_id -- 票据编号
    ,bill_exp_dt -- 票据到期日期
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_exec_int_rat -- 保证金执行利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,flo_val -- 浮动值
    ,aldy_pay_margin_amt -- 已缴保证金金额
    ,sub_acct_num_froz_flow_num -- 子账号冻结流水号
    ,out_acct_flow_num -- 出账流水号
    ,froz_stop_pay_way_cd -- 冻结止付方式代码
    ,froz_stop_pay_type_cd -- 冻结止付类型代码
    ,froz_stop_pay_rs -- 冻结止付原因
    ,off_bs_acct_id -- 表外账户编号
    ,off_bs_acct_name -- 表外账户名称
    ,off_bs_entry_dir_cd -- 表外记账方向代码
    ,off_bs_memo -- 表外摘要
    ,int_accr_way_cd -- 计息方式代码
    ,init_agt_type_cd -- 原协议类型代码
    ,init_agt_id -- 原协议编号
    ,cont_flow_num -- 合同流水号
    ,bus_begin_dt -- 业务起始日期
    ,bus_exp_dt -- 业务到期日期
    ,bus_amt -- 业务金额
    ,bus_bal -- 业务余额
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,flow_status_cd -- 流程状态代码
    ,create_src_cd -- 生成来源代码
    ,curr_brwer_flg -- 当前借款人标志
    ,rels_open_flg -- 释放敞口标志
    ,aldy_revo_flg -- 已撤销标志
    ,batch_flow_num -- 批次流水号
    ,init_tran_flow_num -- 原交易流水号
    ,init_tran_dt -- 原交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,supp_comnt -- 追加说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.appl_flow_num, o.appl_flow_num) as appl_flow_num -- 申请流水号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.margin_acct_id, o.margin_acct_id) as margin_acct_id -- 保证金账户编号
    ,nvl(n.margin_acct_attr_cd, o.margin_acct_attr_cd) as margin_acct_attr_cd -- 保证金账户属性代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.margin_acct_bal, o.margin_acct_bal) as margin_acct_bal -- 保证金账户余额
    ,nvl(n.agt_rat, o.agt_rat) as agt_rat -- 协议利率
    ,nvl(n.dep_base_rat, o.dep_base_rat) as dep_base_rat -- 存款基准利率
    ,nvl(n.dep_term, o.dep_term) as dep_term -- 存期
    ,nvl(n.tran_out_prod_id, o.tran_out_prod_id) as tran_out_prod_id -- 转出产品编号
    ,nvl(n.tran_in_init_acct_flg, o.tran_in_init_acct_flg) as tran_in_init_acct_flg -- 转入原账户标志
    ,nvl(n.margin_tran_in_acct_id, o.margin_tran_in_acct_id) as margin_tran_in_acct_id -- 保证金转入账户编号
    ,nvl(n.margin_type_cd, o.margin_type_cd) as margin_type_cd -- 保证金类型代码
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.bill_exp_dt, o.bill_exp_dt) as bill_exp_dt -- 票据到期日期
    ,nvl(n.margin_int_rat_level_cd, o.margin_int_rat_level_cd) as margin_int_rat_level_cd -- 保证金利率档次代码
    ,nvl(n.margin_exec_int_rat, o.margin_exec_int_rat) as margin_exec_int_rat -- 保证金执行利率
    ,nvl(n.margin_int_rat_type_cd, o.margin_int_rat_type_cd) as margin_int_rat_type_cd -- 保证金利率类型代码
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.int_rat_float_type_cd, o.int_rat_float_type_cd) as int_rat_float_type_cd -- 利率浮动类型代码
    ,nvl(n.flo_val, o.flo_val) as flo_val -- 浮动值
    ,nvl(n.aldy_pay_margin_amt, o.aldy_pay_margin_amt) as aldy_pay_margin_amt -- 已缴保证金金额
    ,nvl(n.sub_acct_num_froz_flow_num, o.sub_acct_num_froz_flow_num) as sub_acct_num_froz_flow_num -- 子账号冻结流水号
    ,nvl(n.out_acct_flow_num, o.out_acct_flow_num) as out_acct_flow_num -- 出账流水号
    ,nvl(n.froz_stop_pay_way_cd, o.froz_stop_pay_way_cd) as froz_stop_pay_way_cd -- 冻结止付方式代码
    ,nvl(n.froz_stop_pay_type_cd, o.froz_stop_pay_type_cd) as froz_stop_pay_type_cd -- 冻结止付类型代码
    ,nvl(n.froz_stop_pay_rs, o.froz_stop_pay_rs) as froz_stop_pay_rs -- 冻结止付原因
    ,nvl(n.off_bs_acct_id, o.off_bs_acct_id) as off_bs_acct_id -- 表外账户编号
    ,nvl(n.off_bs_acct_name, o.off_bs_acct_name) as off_bs_acct_name -- 表外账户名称
    ,nvl(n.off_bs_entry_dir_cd, o.off_bs_entry_dir_cd) as off_bs_entry_dir_cd -- 表外记账方向代码
    ,nvl(n.off_bs_memo, o.off_bs_memo) as off_bs_memo -- 表外摘要
    ,nvl(n.int_accr_way_cd, o.int_accr_way_cd) as int_accr_way_cd -- 计息方式代码
    ,nvl(n.init_agt_type_cd, o.init_agt_type_cd) as init_agt_type_cd -- 原协议类型代码
    ,nvl(n.init_agt_id, o.init_agt_id) as init_agt_id -- 原协议编号
    ,nvl(n.cont_flow_num, o.cont_flow_num) as cont_flow_num -- 合同流水号
    ,nvl(n.bus_begin_dt, o.bus_begin_dt) as bus_begin_dt -- 业务起始日期
    ,nvl(n.bus_exp_dt, o.bus_exp_dt) as bus_exp_dt -- 业务到期日期
    ,nvl(n.bus_amt, o.bus_amt) as bus_amt -- 业务金额
    ,nvl(n.bus_bal, o.bus_bal) as bus_bal -- 业务余额
    ,nvl(n.tran_flow_num, o.tran_flow_num) as tran_flow_num -- 交易流水号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.flow_status_cd, o.flow_status_cd) as flow_status_cd -- 流程状态代码
    ,nvl(n.create_src_cd, o.create_src_cd) as create_src_cd -- 生成来源代码
    ,nvl(n.curr_brwer_flg, o.curr_brwer_flg) as curr_brwer_flg -- 当前借款人标志
    ,nvl(n.rels_open_flg, o.rels_open_flg) as rels_open_flg -- 释放敞口标志
    ,nvl(n.aldy_revo_flg, o.aldy_revo_flg) as aldy_revo_flg -- 已撤销标志
    ,nvl(n.batch_flow_num, o.batch_flow_num) as batch_flow_num -- 批次流水号
    ,nvl(n.init_tran_flow_num, o.init_tran_flow_num) as init_tran_flow_num -- 原交易流水号
    ,nvl(n.init_tran_dt, o.init_tran_dt) as init_tran_dt -- 原交易日期
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,nvl(n.supp_comnt, o.supp_comnt) as supp_comnt -- 追加说明
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_margin_unfrz_appl_icmsf1_tm n
    full join (select * from ${iml_schema}.evt_margin_unfrz_appl_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.appl_flow_num <> n.appl_flow_num
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.margin_acct_id <> n.margin_acct_id
        or o.margin_acct_attr_cd <> n.margin_acct_attr_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.curr_cd <> n.curr_cd
        or o.margin_acct_bal <> n.margin_acct_bal
        or o.agt_rat <> n.agt_rat
        or o.dep_base_rat <> n.dep_base_rat
        or o.dep_term <> n.dep_term
        or o.tran_out_prod_id <> n.tran_out_prod_id
        or o.tran_in_init_acct_flg <> n.tran_in_init_acct_flg
        or o.margin_tran_in_acct_id <> n.margin_tran_in_acct_id
        or o.margin_type_cd <> n.margin_type_cd
        or o.bill_id <> n.bill_id
        or o.bill_exp_dt <> n.bill_exp_dt
        or o.margin_int_rat_level_cd <> n.margin_int_rat_level_cd
        or o.margin_exec_int_rat <> n.margin_exec_int_rat
        or o.margin_int_rat_type_cd <> n.margin_int_rat_type_cd
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.int_rat_float_type_cd <> n.int_rat_float_type_cd
        or o.flo_val <> n.flo_val
        or o.aldy_pay_margin_amt <> n.aldy_pay_margin_amt
        or o.sub_acct_num_froz_flow_num <> n.sub_acct_num_froz_flow_num
        or o.out_acct_flow_num <> n.out_acct_flow_num
        or o.froz_stop_pay_way_cd <> n.froz_stop_pay_way_cd
        or o.froz_stop_pay_type_cd <> n.froz_stop_pay_type_cd
        or o.froz_stop_pay_rs <> n.froz_stop_pay_rs
        or o.off_bs_acct_id <> n.off_bs_acct_id
        or o.off_bs_acct_name <> n.off_bs_acct_name
        or o.off_bs_entry_dir_cd <> n.off_bs_entry_dir_cd
        or o.off_bs_memo <> n.off_bs_memo
        or o.int_accr_way_cd <> n.int_accr_way_cd
        or o.init_agt_type_cd <> n.init_agt_type_cd
        or o.init_agt_id <> n.init_agt_id
        or o.cont_flow_num <> n.cont_flow_num
        or o.bus_begin_dt <> n.bus_begin_dt
        or o.bus_exp_dt <> n.bus_exp_dt
        or o.bus_amt <> n.bus_amt
        or o.bus_bal <> n.bus_bal
        or o.tran_flow_num <> n.tran_flow_num
        or o.tran_dt <> n.tran_dt
        or o.tran_amt <> n.tran_amt
        or o.tran_status_cd <> n.tran_status_cd
        or o.flow_status_cd <> n.flow_status_cd
        or o.create_src_cd <> n.create_src_cd
        or o.curr_brwer_flg <> n.curr_brwer_flg
        or o.rels_open_flg <> n.rels_open_flg
        or o.aldy_revo_flg <> n.aldy_revo_flg
        or o.batch_flow_num <> n.batch_flow_num
        or o.init_tran_flow_num <> n.init_tran_flow_num
        or o.init_tran_dt <> n.init_tran_dt
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.final_update_dt <> n.final_update_dt
        or o.supp_comnt <> n.supp_comnt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_margin_unfrz_appl_icmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,margin_acct_id -- 保证金账户编号
    ,margin_acct_attr_cd -- 保证金账户属性代码
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,margin_acct_bal -- 保证金账户余额
    ,agt_rat -- 协议利率
    ,dep_base_rat -- 存款基准利率
    ,dep_term -- 存期
    ,tran_out_prod_id -- 转出产品编号
    ,tran_in_init_acct_flg -- 转入原账户标志
    ,margin_tran_in_acct_id -- 保证金转入账户编号
    ,margin_type_cd -- 保证金类型代码
    ,bill_id -- 票据编号
    ,bill_exp_dt -- 票据到期日期
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_exec_int_rat -- 保证金执行利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,flo_val -- 浮动值
    ,aldy_pay_margin_amt -- 已缴保证金金额
    ,sub_acct_num_froz_flow_num -- 子账号冻结流水号
    ,out_acct_flow_num -- 出账流水号
    ,froz_stop_pay_way_cd -- 冻结止付方式代码
    ,froz_stop_pay_type_cd -- 冻结止付类型代码
    ,froz_stop_pay_rs -- 冻结止付原因
    ,off_bs_acct_id -- 表外账户编号
    ,off_bs_acct_name -- 表外账户名称
    ,off_bs_entry_dir_cd -- 表外记账方向代码
    ,off_bs_memo -- 表外摘要
    ,int_accr_way_cd -- 计息方式代码
    ,init_agt_type_cd -- 原协议类型代码
    ,init_agt_id -- 原协议编号
    ,cont_flow_num -- 合同流水号
    ,bus_begin_dt -- 业务起始日期
    ,bus_exp_dt -- 业务到期日期
    ,bus_amt -- 业务金额
    ,bus_bal -- 业务余额
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,flow_status_cd -- 流程状态代码
    ,create_src_cd -- 生成来源代码
    ,curr_brwer_flg -- 当前借款人标志
    ,rels_open_flg -- 释放敞口标志
    ,aldy_revo_flg -- 已撤销标志
    ,batch_flow_num -- 批次流水号
    ,init_tran_flow_num -- 原交易流水号
    ,init_tran_dt -- 原交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,supp_comnt -- 追加说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_margin_unfrz_appl_icmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,margin_acct_id -- 保证金账户编号
    ,margin_acct_attr_cd -- 保证金账户属性代码
    ,sub_acct_num -- 子账号
    ,curr_cd -- 币种代码
    ,margin_acct_bal -- 保证金账户余额
    ,agt_rat -- 协议利率
    ,dep_base_rat -- 存款基准利率
    ,dep_term -- 存期
    ,tran_out_prod_id -- 转出产品编号
    ,tran_in_init_acct_flg -- 转入原账户标志
    ,margin_tran_in_acct_id -- 保证金转入账户编号
    ,margin_type_cd -- 保证金类型代码
    ,bill_id -- 票据编号
    ,bill_exp_dt -- 票据到期日期
    ,margin_int_rat_level_cd -- 保证金利率档次代码
    ,margin_exec_int_rat -- 保证金执行利率
    ,margin_int_rat_type_cd -- 保证金利率类型代码
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,flo_val -- 浮动值
    ,aldy_pay_margin_amt -- 已缴保证金金额
    ,sub_acct_num_froz_flow_num -- 子账号冻结流水号
    ,out_acct_flow_num -- 出账流水号
    ,froz_stop_pay_way_cd -- 冻结止付方式代码
    ,froz_stop_pay_type_cd -- 冻结止付类型代码
    ,froz_stop_pay_rs -- 冻结止付原因
    ,off_bs_acct_id -- 表外账户编号
    ,off_bs_acct_name -- 表外账户名称
    ,off_bs_entry_dir_cd -- 表外记账方向代码
    ,off_bs_memo -- 表外摘要
    ,int_accr_way_cd -- 计息方式代码
    ,init_agt_type_cd -- 原协议类型代码
    ,init_agt_id -- 原协议编号
    ,cont_flow_num -- 合同流水号
    ,bus_begin_dt -- 业务起始日期
    ,bus_exp_dt -- 业务到期日期
    ,bus_amt -- 业务金额
    ,bus_bal -- 业务余额
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,flow_status_cd -- 流程状态代码
    ,create_src_cd -- 生成来源代码
    ,curr_brwer_flg -- 当前借款人标志
    ,rels_open_flg -- 释放敞口标志
    ,aldy_revo_flg -- 已撤销标志
    ,batch_flow_num -- 批次流水号
    ,init_tran_flow_num -- 原交易流水号
    ,init_tran_dt -- 原交易日期
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,final_update_dt -- 最后更新日期
    ,supp_comnt -- 追加说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.appl_flow_num -- 申请流水号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.margin_acct_id -- 保证金账户编号
    ,o.margin_acct_attr_cd -- 保证金账户属性代码
    ,o.sub_acct_num -- 子账号
    ,o.curr_cd -- 币种代码
    ,o.margin_acct_bal -- 保证金账户余额
    ,o.agt_rat -- 协议利率
    ,o.dep_base_rat -- 存款基准利率
    ,o.dep_term -- 存期
    ,o.tran_out_prod_id -- 转出产品编号
    ,o.tran_in_init_acct_flg -- 转入原账户标志
    ,o.margin_tran_in_acct_id -- 保证金转入账户编号
    ,o.margin_type_cd -- 保证金类型代码
    ,o.bill_id -- 票据编号
    ,o.bill_exp_dt -- 票据到期日期
    ,o.margin_int_rat_level_cd -- 保证金利率档次代码
    ,o.margin_exec_int_rat -- 保证金执行利率
    ,o.margin_int_rat_type_cd -- 保证金利率类型代码
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.int_rat_float_type_cd -- 利率浮动类型代码
    ,o.flo_val -- 浮动值
    ,o.aldy_pay_margin_amt -- 已缴保证金金额
    ,o.sub_acct_num_froz_flow_num -- 子账号冻结流水号
    ,o.out_acct_flow_num -- 出账流水号
    ,o.froz_stop_pay_way_cd -- 冻结止付方式代码
    ,o.froz_stop_pay_type_cd -- 冻结止付类型代码
    ,o.froz_stop_pay_rs -- 冻结止付原因
    ,o.off_bs_acct_id -- 表外账户编号
    ,o.off_bs_acct_name -- 表外账户名称
    ,o.off_bs_entry_dir_cd -- 表外记账方向代码
    ,o.off_bs_memo -- 表外摘要
    ,o.int_accr_way_cd -- 计息方式代码
    ,o.init_agt_type_cd -- 原协议类型代码
    ,o.init_agt_id -- 原协议编号
    ,o.cont_flow_num -- 合同流水号
    ,o.bus_begin_dt -- 业务起始日期
    ,o.bus_exp_dt -- 业务到期日期
    ,o.bus_amt -- 业务金额
    ,o.bus_bal -- 业务余额
    ,o.tran_flow_num -- 交易流水号
    ,o.tran_dt -- 交易日期
    ,o.tran_amt -- 交易金额
    ,o.tran_status_cd -- 交易状态代码
    ,o.flow_status_cd -- 流程状态代码
    ,o.create_src_cd -- 生成来源代码
    ,o.curr_brwer_flg -- 当前借款人标志
    ,o.rels_open_flg -- 释放敞口标志
    ,o.aldy_revo_flg -- 已撤销标志
    ,o.batch_flow_num -- 批次流水号
    ,o.init_tran_flow_num -- 原交易流水号
    ,o.init_tran_dt -- 原交易日期
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.final_update_dt -- 最后更新日期
    ,o.supp_comnt -- 追加说明
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
from ${iml_schema}.evt_margin_unfrz_appl_icmsf1_bk o
    left join ${iml_schema}.evt_margin_unfrz_appl_icmsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_margin_unfrz_appl_icmsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_margin_unfrz_appl;
--alter table ${iml_schema}.evt_margin_unfrz_appl truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_margin_unfrz_appl') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_margin_unfrz_appl drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_margin_unfrz_appl modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_margin_unfrz_appl exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_cl;
alter table ${iml_schema}.evt_margin_unfrz_appl exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_margin_unfrz_appl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_tm purge;
drop table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_op purge;
drop table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_margin_unfrz_appl_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_margin_unfrz_appl', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
