/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_acct_stl_info_h_ncbsf1
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
alter table ${iml_schema}.agt_loan_acct_stl_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_stl_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,tran_stl_id -- 交易结算编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,evt_cate_id -- 事件类别编号
    ,callbk_id -- 回收编号
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,stl_method_cd -- 结算方法代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,tran_cd -- 交易码
    ,amt_type_cd -- 金额类型代码
    ,stl_cust_id -- 结算客户编号
    ,hxb_stl_flg -- 我行结算标志
    ,stl_bk_bank_no -- 结算行行号
    ,stl_org_id -- 结算机构编号
    ,stl_acct_id -- 结算账户编号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_prod_id -- 结算账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_curr_cd -- 结算币种代码
    ,stl_amt -- 结算金额
    ,stl_exch_rat -- 结算汇率
    ,stl_exch_way_cd -- 结算汇兑方式代码
    ,prior_level -- 优先等级
    ,stl_wt -- 结算权重
    ,auto_lock_flg -- 自动锁定标志
    ,entr_pay_id -- 受托支付编号
    ,froz_id -- 冻结编号
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,entred_ps_acct_froz_way_cd -- 受托人账户冻结方式代码
    ,out_line_flg -- 行内标志
    ,prft_cut_ratio -- 分润比例
    ,contri_ratio -- 出资比例
    ,sel_sup_flg -- 自营标志
    ,stl_acct_bind_mobile_no -- 结算账户绑定手机号码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,acct_cls_cd -- 账户分类代码
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_type_cd -- 挂账类型代码
    ,acct_attr_descb -- 账户属性描述
    ,acct_attr_cd -- 存款账户类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_stl_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_stl_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_stl_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_acct_settle-1
insert into ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,tran_stl_id -- 交易结算编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,evt_cate_id -- 事件类别编号
    ,callbk_id -- 回收编号
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,stl_method_cd -- 结算方法代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,tran_cd -- 交易码
    ,amt_type_cd -- 金额类型代码
    ,stl_cust_id -- 结算客户编号
    ,hxb_stl_flg -- 我行结算标志
    ,stl_bk_bank_no -- 结算行行号
    ,stl_org_id -- 结算机构编号
    ,stl_acct_id -- 结算账户编号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_prod_id -- 结算账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_curr_cd -- 结算币种代码
    ,stl_amt -- 结算金额
    ,stl_exch_rat -- 结算汇率
    ,stl_exch_way_cd -- 结算汇兑方式代码
    ,prior_level -- 优先等级
    ,stl_wt -- 结算权重
    ,auto_lock_flg -- 自动锁定标志
    ,entr_pay_id -- 受托支付编号
    ,froz_id -- 冻结编号
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,entred_ps_acct_froz_way_cd -- 受托人账户冻结方式代码
    ,out_line_flg -- 行内标志
    ,prft_cut_ratio -- 分润比例
    ,contri_ratio -- 出资比例
    ,sel_sup_flg -- 自营标志
    ,stl_acct_bind_mobile_no -- 结算账户绑定手机号码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,acct_cls_cd -- 账户分类代码
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_type_cd -- 挂账类型代码
    ,acct_attr_descb -- 账户属性描述
    ,acct_attr_cd -- 存款账户类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||INTERNAL_KEY -- 协议编号
    ,P1.SETTLE_NO -- 交易结算编号
    ,'9999' -- 法人编号
    ,P1.LOAN_NO -- 贷款号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.EVENT_TYPE -- 事件类别编号
    ,P1.RECEIPT_NO -- 回收编号
    ,NVL(TRIM(P1.SETTLE_ACCT_CLASS),0) -- 结算账户分类代码
    ,P1.SETTLE_METHOD -- 结算方法代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.PAY_REC_IND END -- 收付标识代码
    ,P1.TRAN_TYPE -- 交易码
    ,P1.AMT_TYPE -- 金额类型代码
    ,P1.SETTLE_CLIENT -- 结算客户编号
    ,DECODE(P1.SETTLE_BANK_FLAG,'I','1','O','0') -- 我行结算标志
    ,P1.SETTLE_BANK_NAME -- 结算行行号
    ,P1.SETTLE_BRANCH -- 结算机构编号
    ,P1.SETTLE_ACCT_INTERNAL_KEY -- 结算账户编号
    ,P1.SETTLE_BASE_ACCT_NO -- 结算客户账号
    ,P1.SETTLE_ACCT_NAME -- 结算账户名称
    ,P1.SETTLE_PROD_TYPE -- 结算账户产品编号
    ,P1.SETTLE_ACCT_CCY -- 结算账户币种代码
    ,P1.SETTLE_ACCT_SEQ_NO -- 结算账户子账号
    ,P1.SETTLE_CCY -- 结算币种代码
    ,P1.SETTLE_AMT -- 结算金额
    ,P1.SETTLE_XRATE -- 结算汇率
    ,P1.SETTLE_XRATE_ID -- 结算汇兑方式代码
    ,P1.PRIORITY -- 优先等级
    ,P1.SETTLE_WEIGHT -- 结算权重
    ,DECODE(P1.AUTO_BLOCKING,'Y','1','N','0') -- 自动锁定标志
    ,P1.TRUSTED_PAY_NO -- 受托支付编号
    ,P1.RESTRAINT_SEQ_NO -- 冻结编号
    ,P1.PAYEE_BANK_CODE -- 收款行行号
    ,P1.PAYEE_BANK_NAME -- 收款行名称
    ,P1.FREEZE_TYPE -- 受托人账户冻结方式代码
    ,DECODE(P1.BANK_IN_OUT,'I','1','O','0') -- 行内标志
    ,P1.PROFIT_RATIO -- 分润比例
    ,P1.CONTRIBUTIVE_RATIO -- 出资比例
    ,DECODE(P1.SELF_SUPPORT_FLAG,'Y','1','N','0') -- 自营标志
    ,P1.SETTLE_MOBILE_PHONE -- 结算账户绑定手机号码
    ,P1.USER_ID -- 交易柜员编号
    ,${iml_schema}.timeformat_min(regexp_replace(P1.TRAN_TIMESTAMP,':','.',20,1)) -- 交易时间
    ,P1.RECOVER_FLAG -- 实时追缴标志
    ,P1.PAY_REC_IND -- 账户分类代码
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.HANG_SEQ_NO -- 挂账序号
    ,P1.HANG_OPERATE_TYPE1 -- 挂账类型代码
    ,P1.ACCT_NATURE_DESC -- 账户属性描述
    ,nvl(trim(P1.ACCT_NATURE),'-') -- 存款账户类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_acct_settle' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct_settle p1
    left join ${iml_schema}.ref_pub_cd_map r1 on p1.PAY_REC_IND = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_CL_ACCT_SETTLE'
        AND R1.SRC_FIELD_EN_NAME= 'PAY_REC_IND'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_LOAN_ACCT_STL_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ACPT_PAY_IDF_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,tran_stl_id
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
        into ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,tran_stl_id -- 交易结算编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,evt_cate_id -- 事件类别编号
    ,callbk_id -- 回收编号
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,stl_method_cd -- 结算方法代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,tran_cd -- 交易码
    ,amt_type_cd -- 金额类型代码
    ,stl_cust_id -- 结算客户编号
    ,hxb_stl_flg -- 我行结算标志
    ,stl_bk_bank_no -- 结算行行号
    ,stl_org_id -- 结算机构编号
    ,stl_acct_id -- 结算账户编号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_prod_id -- 结算账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_curr_cd -- 结算币种代码
    ,stl_amt -- 结算金额
    ,stl_exch_rat -- 结算汇率
    ,stl_exch_way_cd -- 结算汇兑方式代码
    ,prior_level -- 优先等级
    ,stl_wt -- 结算权重
    ,auto_lock_flg -- 自动锁定标志
    ,entr_pay_id -- 受托支付编号
    ,froz_id -- 冻结编号
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,entred_ps_acct_froz_way_cd -- 受托人账户冻结方式代码
    ,out_line_flg -- 行内标志
    ,prft_cut_ratio -- 分润比例
    ,contri_ratio -- 出资比例
    ,sel_sup_flg -- 自营标志
    ,stl_acct_bind_mobile_no -- 结算账户绑定手机号码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,acct_cls_cd -- 账户分类代码
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_type_cd -- 挂账类型代码
    ,acct_attr_descb -- 账户属性描述
    ,acct_attr_cd -- 存款账户类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,tran_stl_id -- 交易结算编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,evt_cate_id -- 事件类别编号
    ,callbk_id -- 回收编号
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,stl_method_cd -- 结算方法代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,tran_cd -- 交易码
    ,amt_type_cd -- 金额类型代码
    ,stl_cust_id -- 结算客户编号
    ,hxb_stl_flg -- 我行结算标志
    ,stl_bk_bank_no -- 结算行行号
    ,stl_org_id -- 结算机构编号
    ,stl_acct_id -- 结算账户编号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_prod_id -- 结算账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_curr_cd -- 结算币种代码
    ,stl_amt -- 结算金额
    ,stl_exch_rat -- 结算汇率
    ,stl_exch_way_cd -- 结算汇兑方式代码
    ,prior_level -- 优先等级
    ,stl_wt -- 结算权重
    ,auto_lock_flg -- 自动锁定标志
    ,entr_pay_id -- 受托支付编号
    ,froz_id -- 冻结编号
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,entred_ps_acct_froz_way_cd -- 受托人账户冻结方式代码
    ,out_line_flg -- 行内标志
    ,prft_cut_ratio -- 分润比例
    ,contri_ratio -- 出资比例
    ,sel_sup_flg -- 自营标志
    ,stl_acct_bind_mobile_no -- 结算账户绑定手机号码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,acct_cls_cd -- 账户分类代码
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_type_cd -- 挂账类型代码
    ,acct_attr_descb -- 账户属性描述
    ,acct_attr_cd -- 存款账户类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.tran_stl_id, o.tran_stl_id) as tran_stl_id -- 交易结算编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.loan_num, o.loan_num) as loan_num -- 贷款号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.evt_cate_id, o.evt_cate_id) as evt_cate_id -- 事件类别编号
    ,nvl(n.callbk_id, o.callbk_id) as callbk_id -- 回收编号
    ,nvl(n.stl_acct_cls_cd, o.stl_acct_cls_cd) as stl_acct_cls_cd -- 结算账户分类代码
    ,nvl(n.stl_method_cd, o.stl_method_cd) as stl_method_cd -- 结算方法代码
    ,nvl(n.acpt_pay_idf_cd, o.acpt_pay_idf_cd) as acpt_pay_idf_cd -- 收付标识代码
    ,nvl(n.tran_cd, o.tran_cd) as tran_cd -- 交易码
    ,nvl(n.amt_type_cd, o.amt_type_cd) as amt_type_cd -- 金额类型代码
    ,nvl(n.stl_cust_id, o.stl_cust_id) as stl_cust_id -- 结算客户编号
    ,nvl(n.hxb_stl_flg, o.hxb_stl_flg) as hxb_stl_flg -- 我行结算标志
    ,nvl(n.stl_bk_bank_no, o.stl_bk_bank_no) as stl_bk_bank_no -- 结算行行号
    ,nvl(n.stl_org_id, o.stl_org_id) as stl_org_id -- 结算机构编号
    ,nvl(n.stl_acct_id, o.stl_acct_id) as stl_acct_id -- 结算账户编号
    ,nvl(n.stl_cust_acct_num, o.stl_cust_acct_num) as stl_cust_acct_num -- 结算客户账号
    ,nvl(n.stl_acct_name, o.stl_acct_name) as stl_acct_name -- 结算账户名称
    ,nvl(n.stl_acct_prod_id, o.stl_acct_prod_id) as stl_acct_prod_id -- 结算账户产品编号
    ,nvl(n.stl_acct_curr_cd, o.stl_acct_curr_cd) as stl_acct_curr_cd -- 结算账户币种代码
    ,nvl(n.stl_acct_sub_acct_num, o.stl_acct_sub_acct_num) as stl_acct_sub_acct_num -- 结算账户子账号
    ,nvl(n.stl_curr_cd, o.stl_curr_cd) as stl_curr_cd -- 结算币种代码
    ,nvl(n.stl_amt, o.stl_amt) as stl_amt -- 结算金额
    ,nvl(n.stl_exch_rat, o.stl_exch_rat) as stl_exch_rat -- 结算汇率
    ,nvl(n.stl_exch_way_cd, o.stl_exch_way_cd) as stl_exch_way_cd -- 结算汇兑方式代码
    ,nvl(n.prior_level, o.prior_level) as prior_level -- 优先等级
    ,nvl(n.stl_wt, o.stl_wt) as stl_wt -- 结算权重
    ,nvl(n.auto_lock_flg, o.auto_lock_flg) as auto_lock_flg -- 自动锁定标志
    ,nvl(n.entr_pay_id, o.entr_pay_id) as entr_pay_id -- 受托支付编号
    ,nvl(n.froz_id, o.froz_id) as froz_id -- 冻结编号
    ,nvl(n.recv_bank_no, o.recv_bank_no) as recv_bank_no -- 收款行行号
    ,nvl(n.recv_bank_name, o.recv_bank_name) as recv_bank_name -- 收款行名称
    ,nvl(n.entred_ps_acct_froz_way_cd, o.entred_ps_acct_froz_way_cd) as entred_ps_acct_froz_way_cd -- 受托人账户冻结方式代码
    ,nvl(n.out_line_flg, o.out_line_flg) as out_line_flg -- 行内标志
    ,nvl(n.prft_cut_ratio, o.prft_cut_ratio) as prft_cut_ratio -- 分润比例
    ,nvl(n.contri_ratio, o.contri_ratio) as contri_ratio -- 出资比例
    ,nvl(n.sel_sup_flg, o.sel_sup_flg) as sel_sup_flg -- 自营标志
    ,nvl(n.stl_acct_bind_mobile_no, o.stl_acct_bind_mobile_no) as stl_acct_bind_mobile_no -- 结算账户绑定手机号码
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.realtm_chase_capt_flg, o.realtm_chase_capt_flg) as realtm_chase_capt_flg -- 实时追缴标志
    ,nvl(n.acct_cls_cd, o.acct_cls_cd) as acct_cls_cd -- 账户分类代码
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.on_acct_seq_num, o.on_acct_seq_num) as on_acct_seq_num -- 挂账序号
    ,nvl(n.on_acct_type_cd, o.on_acct_type_cd) as on_acct_type_cd -- 挂账类型代码
    ,nvl(n.acct_attr_descb, o.acct_attr_descb) as acct_attr_descb -- 账户属性描述
    ,nvl(n.acct_attr_cd, o.acct_attr_cd) as acct_attr_cd -- 存款账户类型代码
    ,case when
            n.agt_id is null
            and n.tran_stl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.tran_stl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.tran_stl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.tran_stl_id = n.tran_stl_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.tran_stl_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.tran_stl_id is null
        and n.lp_id is null
    )
    or (
        o.loan_num <> n.loan_num
        or o.acct_id <> n.acct_id
        or o.cust_id <> n.cust_id
        or o.evt_cate_id <> n.evt_cate_id
        or o.callbk_id <> n.callbk_id
        or o.stl_acct_cls_cd <> n.stl_acct_cls_cd
        or o.stl_method_cd <> n.stl_method_cd
        or o.acpt_pay_idf_cd <> n.acpt_pay_idf_cd
        or o.tran_cd <> n.tran_cd
        or o.amt_type_cd <> n.amt_type_cd
        or o.stl_cust_id <> n.stl_cust_id
        or o.hxb_stl_flg <> n.hxb_stl_flg
        or o.stl_bk_bank_no <> n.stl_bk_bank_no
        or o.stl_org_id <> n.stl_org_id
        or o.stl_acct_id <> n.stl_acct_id
        or o.stl_cust_acct_num <> n.stl_cust_acct_num
        or o.stl_acct_name <> n.stl_acct_name
        or o.stl_acct_prod_id <> n.stl_acct_prod_id
        or o.stl_acct_curr_cd <> n.stl_acct_curr_cd
        or o.stl_acct_sub_acct_num <> n.stl_acct_sub_acct_num
        or o.stl_curr_cd <> n.stl_curr_cd
        or o.stl_amt <> n.stl_amt
        or o.stl_exch_rat <> n.stl_exch_rat
        or o.stl_exch_way_cd <> n.stl_exch_way_cd
        or o.prior_level <> n.prior_level
        or o.stl_wt <> n.stl_wt
        or o.auto_lock_flg <> n.auto_lock_flg
        or o.entr_pay_id <> n.entr_pay_id
        or o.froz_id <> n.froz_id
        or o.recv_bank_no <> n.recv_bank_no
        or o.recv_bank_name <> n.recv_bank_name
        or o.entred_ps_acct_froz_way_cd <> n.entred_ps_acct_froz_way_cd
        or o.out_line_flg <> n.out_line_flg
        or o.prft_cut_ratio <> n.prft_cut_ratio
        or o.contri_ratio <> n.contri_ratio
        or o.sel_sup_flg <> n.sel_sup_flg
        or o.stl_acct_bind_mobile_no <> n.stl_acct_bind_mobile_no
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_tm <> n.tran_tm
        or o.realtm_chase_capt_flg <> n.realtm_chase_capt_flg
        or o.acct_cls_cd <> n.acct_cls_cd
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.final_modif_dt <> n.final_modif_dt
        or o.on_acct_seq_num <> n.on_acct_seq_num
        or o.on_acct_type_cd <> n.on_acct_type_cd
        or o.acct_attr_descb <> n.acct_attr_descb
        or o.acct_attr_cd <> n.acct_attr_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,tran_stl_id -- 交易结算编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,evt_cate_id -- 事件类别编号
    ,callbk_id -- 回收编号
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,stl_method_cd -- 结算方法代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,tran_cd -- 交易码
    ,amt_type_cd -- 金额类型代码
    ,stl_cust_id -- 结算客户编号
    ,hxb_stl_flg -- 我行结算标志
    ,stl_bk_bank_no -- 结算行行号
    ,stl_org_id -- 结算机构编号
    ,stl_acct_id -- 结算账户编号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_prod_id -- 结算账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_curr_cd -- 结算币种代码
    ,stl_amt -- 结算金额
    ,stl_exch_rat -- 结算汇率
    ,stl_exch_way_cd -- 结算汇兑方式代码
    ,prior_level -- 优先等级
    ,stl_wt -- 结算权重
    ,auto_lock_flg -- 自动锁定标志
    ,entr_pay_id -- 受托支付编号
    ,froz_id -- 冻结编号
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,entred_ps_acct_froz_way_cd -- 受托人账户冻结方式代码
    ,out_line_flg -- 行内标志
    ,prft_cut_ratio -- 分润比例
    ,contri_ratio -- 出资比例
    ,sel_sup_flg -- 自营标志
    ,stl_acct_bind_mobile_no -- 结算账户绑定手机号码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,acct_cls_cd -- 账户分类代码
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_type_cd -- 挂账类型代码
    ,acct_attr_descb -- 账户属性描述
    ,acct_attr_cd -- 存款账户类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,tran_stl_id -- 交易结算编号
    ,lp_id -- 法人编号
    ,loan_num -- 贷款号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,evt_cate_id -- 事件类别编号
    ,callbk_id -- 回收编号
    ,stl_acct_cls_cd -- 结算账户分类代码
    ,stl_method_cd -- 结算方法代码
    ,acpt_pay_idf_cd -- 收付标识代码
    ,tran_cd -- 交易码
    ,amt_type_cd -- 金额类型代码
    ,stl_cust_id -- 结算客户编号
    ,hxb_stl_flg -- 我行结算标志
    ,stl_bk_bank_no -- 结算行行号
    ,stl_org_id -- 结算机构编号
    ,stl_acct_id -- 结算账户编号
    ,stl_cust_acct_num -- 结算客户账号
    ,stl_acct_name -- 结算账户名称
    ,stl_acct_prod_id -- 结算账户产品编号
    ,stl_acct_curr_cd -- 结算账户币种代码
    ,stl_acct_sub_acct_num -- 结算账户子账号
    ,stl_curr_cd -- 结算币种代码
    ,stl_amt -- 结算金额
    ,stl_exch_rat -- 结算汇率
    ,stl_exch_way_cd -- 结算汇兑方式代码
    ,prior_level -- 优先等级
    ,stl_wt -- 结算权重
    ,auto_lock_flg -- 自动锁定标志
    ,entr_pay_id -- 受托支付编号
    ,froz_id -- 冻结编号
    ,recv_bank_no -- 收款行行号
    ,recv_bank_name -- 收款行名称
    ,entred_ps_acct_froz_way_cd -- 受托人账户冻结方式代码
    ,out_line_flg -- 行内标志
    ,prft_cut_ratio -- 分润比例
    ,contri_ratio -- 出资比例
    ,sel_sup_flg -- 自营标志
    ,stl_acct_bind_mobile_no -- 结算账户绑定手机号码
    ,tran_teller_id -- 交易柜员编号
    ,tran_tm -- 交易时间
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,acct_cls_cd -- 账户分类代码
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_type_cd -- 挂账类型代码
    ,acct_attr_descb -- 账户属性描述
    ,acct_attr_cd -- 存款账户类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.tran_stl_id -- 交易结算编号
    ,o.lp_id -- 法人编号
    ,o.loan_num -- 贷款号
    ,o.acct_id -- 账户编号
    ,o.cust_id -- 客户编号
    ,o.evt_cate_id -- 事件类别编号
    ,o.callbk_id -- 回收编号
    ,o.stl_acct_cls_cd -- 结算账户分类代码
    ,o.stl_method_cd -- 结算方法代码
    ,o.acpt_pay_idf_cd -- 收付标识代码
    ,o.tran_cd -- 交易码
    ,o.amt_type_cd -- 金额类型代码
    ,o.stl_cust_id -- 结算客户编号
    ,o.hxb_stl_flg -- 我行结算标志
    ,o.stl_bk_bank_no -- 结算行行号
    ,o.stl_org_id -- 结算机构编号
    ,o.stl_acct_id -- 结算账户编号
    ,o.stl_cust_acct_num -- 结算客户账号
    ,o.stl_acct_name -- 结算账户名称
    ,o.stl_acct_prod_id -- 结算账户产品编号
    ,o.stl_acct_curr_cd -- 结算账户币种代码
    ,o.stl_acct_sub_acct_num -- 结算账户子账号
    ,o.stl_curr_cd -- 结算币种代码
    ,o.stl_amt -- 结算金额
    ,o.stl_exch_rat -- 结算汇率
    ,o.stl_exch_way_cd -- 结算汇兑方式代码
    ,o.prior_level -- 优先等级
    ,o.stl_wt -- 结算权重
    ,o.auto_lock_flg -- 自动锁定标志
    ,o.entr_pay_id -- 受托支付编号
    ,o.froz_id -- 冻结编号
    ,o.recv_bank_no -- 收款行行号
    ,o.recv_bank_name -- 收款行名称
    ,o.entred_ps_acct_froz_way_cd -- 受托人账户冻结方式代码
    ,o.out_line_flg -- 行内标志
    ,o.prft_cut_ratio -- 分润比例
    ,o.contri_ratio -- 出资比例
    ,o.sel_sup_flg -- 自营标志
    ,o.stl_acct_bind_mobile_no -- 结算账户绑定手机号码
    ,o.tran_teller_id -- 交易柜员编号
    ,o.tran_tm -- 交易时间
    ,o.realtm_chase_capt_flg -- 实时追缴标志
    ,o.acct_cls_cd -- 账户分类代码
    ,o.final_modif_teller_id -- 最后修改柜员编号
    ,o.final_modif_dt -- 最后修改日期
    ,o.on_acct_seq_num -- 挂账序号
    ,o.on_acct_type_cd -- 挂账类型代码
    ,o.acct_attr_descb -- 账户属性描述
    ,o.acct_attr_cd -- 存款账户类型代码
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
from ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.tran_stl_id = n.tran_stl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.tran_stl_id = d.tran_stl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_acct_stl_info_h;
--alter table ${iml_schema}.agt_loan_acct_stl_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_acct_stl_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_acct_stl_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_acct_stl_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_acct_stl_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_loan_acct_stl_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_acct_stl_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_acct_stl_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_acct_stl_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
