/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_cds_h_ncbsf1
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
alter table ${iml_schema}.agt_cds_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_cds_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_cds_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cds_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cds_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cds_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,precon_rgst_acct_type -- 预约登记账户类型代码
    ,precon_org -- 预约机构编号
    ,precon_curr_cd -- 预约币种代码
    ,precon_amt -- 预约金额
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,comb_prod_id -- 组合产品编号
    ,acct_name -- 账户名称
    ,seq_num -- 序号
    ,on_acct_seq_num -- 挂账序号
    ,supp_on_acct_sub_seq_num -- 追加挂账子序号
    ,tran_amt -- 交易金额
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,pd_issue_amt -- 期次发行金额
    ,issue_year -- 发行年度
    ,issue_begin_dt -- 发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,chn_id -- 渠道编号
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_sub_acct_num -- 对手子账号
    ,cntpty_prod_id -- 对手产品编号
    ,lmt_id -- 限制编号
    ,vouch_no -- 凭证号码
    ,auto_payoff_flg -- 自动结清标志
    ,bank_int_int_rat -- 行内利率
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_set_day -- 结息日
    ,int_set_freq_cd -- 结息频率代码
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,next_int_set_dt -- 下一结息日期
    ,tran_ref_no -- 交易参考号
    ,teller_id -- 柜员编号
    ,acct_status_cd -- 账户状态代码
    ,redem_dt -- 赎回日期
    ,expect_redem_int -- 预计赎回利息
    ,inpwn_flg -- 质押标志
    ,wdraw_way_cd -- 支取方式代码
    ,acct_attr_cd -- 账户属性代码
    ,cntpty_acct_name -- 对手账户名称
    ,potd_acct_id -- 定期一本通账户编号
    ,cds_int_accr_way_cd -- 大额存单计息方式代码
    ,subscr_acct_id -- 认购账户编号
    ,col_int_acct_id -- 收息账户编号
    ,del_dt -- 删除日期
    ,fail_rs_descb -- 失败原因描述
    ,memo -- 摘要
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,revo_dt -- 撤单日期
    ,dep_char_cd -- 存款性质代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_cds_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_cds_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_cds_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_dc_precontract-1
insert into ${iml_schema}.agt_cds_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,precon_rgst_acct_type -- 预约登记账户类型代码
    ,precon_org -- 预约机构编号
    ,precon_curr_cd -- 预约币种代码
    ,precon_amt -- 预约金额
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,comb_prod_id -- 组合产品编号
    ,acct_name -- 账户名称
    ,seq_num -- 序号
    ,on_acct_seq_num -- 挂账序号
    ,supp_on_acct_sub_seq_num -- 追加挂账子序号
    ,tran_amt -- 交易金额
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,pd_issue_amt -- 期次发行金额
    ,issue_year -- 发行年度
    ,issue_begin_dt -- 发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,chn_id -- 渠道编号
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_sub_acct_num -- 对手子账号
    ,cntpty_prod_id -- 对手产品编号
    ,lmt_id -- 限制编号
    ,vouch_no -- 凭证号码
    ,auto_payoff_flg -- 自动结清标志
    ,bank_int_int_rat -- 行内利率
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_set_day -- 结息日
    ,int_set_freq_cd -- 结息频率代码
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,next_int_set_dt -- 下一结息日期
    ,tran_ref_no -- 交易参考号
    ,teller_id -- 柜员编号
    ,acct_status_cd -- 账户状态代码
    ,redem_dt -- 赎回日期
    ,expect_redem_int -- 预计赎回利息
    ,inpwn_flg -- 质押标志
    ,wdraw_way_cd -- 支取方式代码
    ,acct_attr_cd -- 账户属性代码
    ,cntpty_acct_name -- 对手账户名称
    ,potd_acct_id -- 定期一本通账户编号
    ,cds_int_accr_way_cd -- 大额存单计息方式代码
    ,subscr_acct_id -- 认购账户编号
    ,col_int_acct_id -- 收息账户编号
    ,del_dt -- 删除日期
    ,fail_rs_descb -- 失败原因描述
    ,memo -- 摘要
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,revo_dt -- 撤单日期
    ,dep_char_cd -- 存款性质代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '120010'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.PRECONTRACT_NO -- 预约编号
    ,P1.PRECONTRACT_DATE -- 预约登记日期
    ,P1.PRECONTRACT_OPEN_DATE -- 预约开户日期
    ,nvl(trim(P1.PRECONTRACT_TYPE),'-') -- 预约登记账户类型代码
    ,P1.PRECONTRACT_BRANCH -- 预约机构编号
    ,nvl(trim(P1.PRECONTRACT_CCY),'-') -- 预约币种代码
    ,P1.PRECONTRACT_AMT -- 预约金额
    ,P1.PRECONTRACT_STATUS -- 期次产品预约状态代码
    ,P1.CLIENT_NO -- 客户编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,nvl(trim(p8.card_no),p1.BASE_ACCT_NO) -- 客户账号
    ,nvl(trim(P1.ACCT_CCY),'-') -- 币种代码
    ,P1.ACCT_SEQ_NO -- 子账号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.COMB_PROD_NO -- 组合产品编号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.SEQ_NO -- 序号
    ,P1.HANG_SEQ_NO -- 挂账序号
    ,P1.SUB_HANG_SEQ_NO -- 追加挂账子序号
    ,nvl(trim(P1.TRAN_AMT),0) -- 交易金额
    ,P1.STAGE_CODE -- 期次编号
    ,P1.STAGE_PROD_CLASS -- 期次产品类别代码
    ,P1.ISSUE_AMT -- 期次发行金额
    ,P1.ISSUE_YEAR -- 发行年度
    ,P1.ISSUE_START_DATE -- 发行起始日期
    ,P1.ISSUE_END_DATE -- 发行终止日期
    ,P1.CHANNEL -- 渠道编号
    ,P1.OTH_INTERNAL_KEY -- 对手账户编号
    ,nvl(trim(p9.card_no),p1.OTH_BASE_ACCT_NO) -- 对手客户账号
    ,nvl(trim(P1.OTH_CCY),'-') -- 对手账户币种代码
    ,P1.OTH_ACCT_SEQ_NO -- 对手子账号
    ,P1.OTH_PROD_TYPE -- 对手产品编号
    ,P1.RES_SEQ_NO -- 限制编号
    ,P1.VOUCHER_NO -- 凭证号码
    ,decode(trim(p1.AUTO_SETTLE_FLAG),'','-','Y','1','N','0',p1.AUTO_SETTLE_FLAG) -- 自动结清标志
    ,P1.ACTUAL_RATE -- 行内利率
    ,P1.REAL_RATE -- 执行利率
    ,P1.FLOAT_RATE -- 浮动利率
    ,nvl(trim(P1.INT_TYPE),'-') -- 利率类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.INT_CALC_TYPE END -- 利率调整方式代码
    ,NVL(TRIM(P1.INT_DAY),0) -- 结息日
    ,nvl(trim(P1.CYCLE_FREQ),'-') -- 结息频率代码
    ,decode(trim(p1.CYCLE_INT_FLAG),'','-','Y','1','N','0',p1.CYCLE_INT_FLAG) -- 按频率付息标志
    ,P1.NEXT_CYCLE_DATE -- 下一结息日期
    ,P1.REFERENCE -- 交易参考号
    ,P1.USER_ID -- 柜员编号
    ,nvl(trim(P1.ACCT_STATUS),'-') -- 账户状态代码
    ,P1.REDEEM_DATE -- 赎回日期
    ,P1.EXP_REDEEM_INT_AMT -- 预计赎回利息
    ,decode(trim(p1.PLEDGED_FLAG),'','-','Y','1','N','0',p1.PLEDGED_FLAG) -- 质押标志
    ,nvl(trim(P1.WITHDRAWAL_TYPE),'-') -- 支取方式代码
    ,nvl(trim(P1.ACCT_NATURE),'-') -- 账户属性代码
    ,P1.OTH_ACCT_NAME -- 对手账户名称
    ,P1.DEP_TERM_INTERNAL_KEY -- 定期一本通账户编号
    ,nvl(trim(P1.ACCT_INT_TYPE),'-') -- 大额存单计息方式代码
    ,P1.SUBS_INTERNAL_KEY -- 认购账户编号
    ,P1.CHARGE_INT_INTERNAL_KEY -- 收息账户编号
    ,P1.DELETE_DATE -- 删除日期
    ,P1.FAILURE_REASON -- 失败原因描述
    ,P1.NARRATIVE -- 摘要
    ,P1.DEL_AUTH_USER_ID -- 删除授权柜员编号
    ,P1.DEL_USER_ID -- 删除柜员编号
    ,P1.CANCEL_DATE -- 撤单日期
    ,nvl(trim(P1.DEPOSIT_NATURE),'-') -- 存款性质代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_dc_precontract' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_precontract p1
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p8 on p1.BASE_ACCT_NO=p8.BASE_ACCT_NO and p8.BASE_ACCT_NO LIKE '0%' 
    left join (select distinct base_acct_no,card_no from ${iol_schema}.ncbs_new_old_seq_no) p9 on p1.OTH_BASE_ACCT_NO=p9.BASE_ACCT_NO and p9.BASE_ACCT_NO LIKE '0%'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.INT_CALC_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_RB_DC_PRECONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'INT_CALC_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_CDS_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_cds_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,precon_id
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
        into ${iml_schema}.agt_cds_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,precon_rgst_acct_type -- 预约登记账户类型代码
    ,precon_org -- 预约机构编号
    ,precon_curr_cd -- 预约币种代码
    ,precon_amt -- 预约金额
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,comb_prod_id -- 组合产品编号
    ,acct_name -- 账户名称
    ,seq_num -- 序号
    ,on_acct_seq_num -- 挂账序号
    ,supp_on_acct_sub_seq_num -- 追加挂账子序号
    ,tran_amt -- 交易金额
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,pd_issue_amt -- 期次发行金额
    ,issue_year -- 发行年度
    ,issue_begin_dt -- 发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,chn_id -- 渠道编号
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_sub_acct_num -- 对手子账号
    ,cntpty_prod_id -- 对手产品编号
    ,lmt_id -- 限制编号
    ,vouch_no -- 凭证号码
    ,auto_payoff_flg -- 自动结清标志
    ,bank_int_int_rat -- 行内利率
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_set_day -- 结息日
    ,int_set_freq_cd -- 结息频率代码
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,next_int_set_dt -- 下一结息日期
    ,tran_ref_no -- 交易参考号
    ,teller_id -- 柜员编号
    ,acct_status_cd -- 账户状态代码
    ,redem_dt -- 赎回日期
    ,expect_redem_int -- 预计赎回利息
    ,inpwn_flg -- 质押标志
    ,wdraw_way_cd -- 支取方式代码
    ,acct_attr_cd -- 账户属性代码
    ,cntpty_acct_name -- 对手账户名称
    ,potd_acct_id -- 定期一本通账户编号
    ,cds_int_accr_way_cd -- 大额存单计息方式代码
    ,subscr_acct_id -- 认购账户编号
    ,col_int_acct_id -- 收息账户编号
    ,del_dt -- 删除日期
    ,fail_rs_descb -- 失败原因描述
    ,memo -- 摘要
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,revo_dt -- 撤单日期
    ,dep_char_cd -- 存款性质代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cds_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,precon_rgst_acct_type -- 预约登记账户类型代码
    ,precon_org -- 预约机构编号
    ,precon_curr_cd -- 预约币种代码
    ,precon_amt -- 预约金额
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,comb_prod_id -- 组合产品编号
    ,acct_name -- 账户名称
    ,seq_num -- 序号
    ,on_acct_seq_num -- 挂账序号
    ,supp_on_acct_sub_seq_num -- 追加挂账子序号
    ,tran_amt -- 交易金额
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,pd_issue_amt -- 期次发行金额
    ,issue_year -- 发行年度
    ,issue_begin_dt -- 发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,chn_id -- 渠道编号
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_sub_acct_num -- 对手子账号
    ,cntpty_prod_id -- 对手产品编号
    ,lmt_id -- 限制编号
    ,vouch_no -- 凭证号码
    ,auto_payoff_flg -- 自动结清标志
    ,bank_int_int_rat -- 行内利率
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_set_day -- 结息日
    ,int_set_freq_cd -- 结息频率代码
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,next_int_set_dt -- 下一结息日期
    ,tran_ref_no -- 交易参考号
    ,teller_id -- 柜员编号
    ,acct_status_cd -- 账户状态代码
    ,redem_dt -- 赎回日期
    ,expect_redem_int -- 预计赎回利息
    ,inpwn_flg -- 质押标志
    ,wdraw_way_cd -- 支取方式代码
    ,acct_attr_cd -- 账户属性代码
    ,cntpty_acct_name -- 对手账户名称
    ,potd_acct_id -- 定期一本通账户编号
    ,cds_int_accr_way_cd -- 大额存单计息方式代码
    ,subscr_acct_id -- 认购账户编号
    ,col_int_acct_id -- 收息账户编号
    ,del_dt -- 删除日期
    ,fail_rs_descb -- 失败原因描述
    ,memo -- 摘要
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,revo_dt -- 撤单日期
    ,dep_char_cd -- 存款性质代码
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
    ,nvl(n.precon_rgst_dt, o.precon_rgst_dt) as precon_rgst_dt -- 预约登记日期
    ,nvl(n.precon_open_acct_dt, o.precon_open_acct_dt) as precon_open_acct_dt -- 预约开户日期
    ,nvl(n.precon_rgst_acct_type, o.precon_rgst_acct_type) as precon_rgst_acct_type -- 预约登记账户类型代码
    ,nvl(n.precon_org, o.precon_org) as precon_org -- 预约机构编号
    ,nvl(n.precon_curr_cd, o.precon_curr_cd) as precon_curr_cd -- 预约币种代码
    ,nvl(n.precon_amt, o.precon_amt) as precon_amt -- 预约金额
    ,nvl(n.pd_prod_precon_status_cd, o.pd_prod_precon_status_cd) as pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.comb_prod_id, o.comb_prod_id) as comb_prod_id -- 组合产品编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.seq_num, o.seq_num) as seq_num -- 序号
    ,nvl(n.on_acct_seq_num, o.on_acct_seq_num) as on_acct_seq_num -- 挂账序号
    ,nvl(n.supp_on_acct_sub_seq_num, o.supp_on_acct_sub_seq_num) as supp_on_acct_sub_seq_num -- 追加挂账子序号
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.pd_cd, o.pd_cd) as pd_cd -- 期次编号
    ,nvl(n.pd_prod_cate_cd, o.pd_prod_cate_cd) as pd_prod_cate_cd -- 期次产品类别代码
    ,nvl(n.pd_issue_amt, o.pd_issue_amt) as pd_issue_amt -- 期次发行金额
    ,nvl(n.issue_year, o.issue_year) as issue_year -- 发行年度
    ,nvl(n.issue_begin_dt, o.issue_begin_dt) as issue_begin_dt -- 发行起始日期
    ,nvl(n.issue_termnt_dt, o.issue_termnt_dt) as issue_termnt_dt -- 发行终止日期
    ,nvl(n.chn_id, o.chn_id) as chn_id -- 渠道编号
    ,nvl(n.cntpty_acct_id, o.cntpty_acct_id) as cntpty_acct_id -- 对手账户编号
    ,nvl(n.cntpty_cust_acct_num, o.cntpty_cust_acct_num) as cntpty_cust_acct_num -- 对手客户账号
    ,nvl(n.cntpty_acct_curr_cd, o.cntpty_acct_curr_cd) as cntpty_acct_curr_cd -- 对手账户币种代码
    ,nvl(n.cntpty_sub_acct_num, o.cntpty_sub_acct_num) as cntpty_sub_acct_num -- 对手子账号
    ,nvl(n.cntpty_prod_id, o.cntpty_prod_id) as cntpty_prod_id -- 对手产品编号
    ,nvl(n.lmt_id, o.lmt_id) as lmt_id -- 限制编号
    ,nvl(n.vouch_no, o.vouch_no) as vouch_no -- 凭证号码
    ,nvl(n.auto_payoff_flg, o.auto_payoff_flg) as auto_payoff_flg -- 自动结清标志
    ,nvl(n.bank_int_int_rat, o.bank_int_int_rat) as bank_int_int_rat -- 行内利率
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.float_int_rat, o.float_int_rat) as float_int_rat -- 浮动利率
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_set_day, o.int_set_day) as int_set_day -- 结息日
    ,nvl(n.int_set_freq_cd, o.int_set_freq_cd) as int_set_freq_cd -- 结息频率代码
    ,nvl(n.accrd_freq_pay_int_flg, o.accrd_freq_pay_int_flg) as accrd_freq_pay_int_flg -- 按频率付息标志
    ,nvl(n.next_int_set_dt, o.next_int_set_dt) as next_int_set_dt -- 下一结息日期
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.teller_id, o.teller_id) as teller_id -- 柜员编号
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.redem_dt, o.redem_dt) as redem_dt -- 赎回日期
    ,nvl(n.expect_redem_int, o.expect_redem_int) as expect_redem_int -- 预计赎回利息
    ,nvl(n.inpwn_flg, o.inpwn_flg) as inpwn_flg -- 质押标志
    ,nvl(n.wdraw_way_cd, o.wdraw_way_cd) as wdraw_way_cd -- 支取方式代码
    ,nvl(n.acct_attr_cd, o.acct_attr_cd) as acct_attr_cd -- 账户属性代码
    ,nvl(n.cntpty_acct_name, o.cntpty_acct_name) as cntpty_acct_name -- 对手账户名称
    ,nvl(n.potd_acct_id, o.potd_acct_id) as potd_acct_id -- 定期一本通账户编号
    ,nvl(n.cds_int_accr_way_cd, o.cds_int_accr_way_cd) as cds_int_accr_way_cd -- 大额存单计息方式代码
    ,nvl(n.subscr_acct_id, o.subscr_acct_id) as subscr_acct_id -- 认购账户编号
    ,nvl(n.col_int_acct_id, o.col_int_acct_id) as col_int_acct_id -- 收息账户编号
    ,nvl(n.del_dt, o.del_dt) as del_dt -- 删除日期
    ,nvl(n.fail_rs_descb, o.fail_rs_descb) as fail_rs_descb -- 失败原因描述
    ,nvl(n.memo, o.memo) as memo -- 摘要
    ,nvl(n.del_auth_teller_id, o.del_auth_teller_id) as del_auth_teller_id -- 删除授权柜员编号
    ,nvl(n.del_teller_id, o.del_teller_id) as del_teller_id -- 删除柜员编号
    ,nvl(n.revo_dt, o.revo_dt) as revo_dt -- 撤单日期
    ,nvl(n.dep_char_cd, o.dep_char_cd) as dep_char_cd -- 存款性质代码
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.precon_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.precon_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.precon_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_cds_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_cds_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.precon_id = n.precon_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.precon_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.precon_id is null
    )
    or (
        o.precon_rgst_dt <> n.precon_rgst_dt
        or o.precon_open_acct_dt <> n.precon_open_acct_dt
        or o.precon_rgst_acct_type <> n.precon_rgst_acct_type
        or o.precon_org <> n.precon_org
        or o.precon_curr_cd <> n.precon_curr_cd
        or o.precon_amt <> n.precon_amt
        or o.pd_prod_precon_status_cd <> n.pd_prod_precon_status_cd
        or o.cust_id <> n.cust_id
        or o.acct_id <> n.acct_id
        or o.cust_acct_num <> n.cust_acct_num
        or o.curr_cd <> n.curr_cd
        or o.sub_acct_num <> n.sub_acct_num
        or o.prod_id <> n.prod_id
        or o.comb_prod_id <> n.comb_prod_id
        or o.acct_name <> n.acct_name
        or o.seq_num <> n.seq_num
        or o.on_acct_seq_num <> n.on_acct_seq_num
        or o.supp_on_acct_sub_seq_num <> n.supp_on_acct_sub_seq_num
        or o.tran_amt <> n.tran_amt
        or o.pd_cd <> n.pd_cd
        or o.pd_prod_cate_cd <> n.pd_prod_cate_cd
        or o.pd_issue_amt <> n.pd_issue_amt
        or o.issue_year <> n.issue_year
        or o.issue_begin_dt <> n.issue_begin_dt
        or o.issue_termnt_dt <> n.issue_termnt_dt
        or o.chn_id <> n.chn_id
        or o.cntpty_acct_id <> n.cntpty_acct_id
        or o.cntpty_cust_acct_num <> n.cntpty_cust_acct_num
        or o.cntpty_acct_curr_cd <> n.cntpty_acct_curr_cd
        or o.cntpty_sub_acct_num <> n.cntpty_sub_acct_num
        or o.cntpty_prod_id <> n.cntpty_prod_id
        or o.lmt_id <> n.lmt_id
        or o.vouch_no <> n.vouch_no
        or o.auto_payoff_flg <> n.auto_payoff_flg
        or o.bank_int_int_rat <> n.bank_int_int_rat
        or o.exec_int_rat <> n.exec_int_rat
        or o.float_int_rat <> n.float_int_rat
        or o.int_rat_type_cd <> n.int_rat_type_cd
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_set_day <> n.int_set_day
        or o.int_set_freq_cd <> n.int_set_freq_cd
        or o.accrd_freq_pay_int_flg <> n.accrd_freq_pay_int_flg
        or o.next_int_set_dt <> n.next_int_set_dt
        or o.tran_ref_no <> n.tran_ref_no
        or o.teller_id <> n.teller_id
        or o.acct_status_cd <> n.acct_status_cd
        or o.redem_dt <> n.redem_dt
        or o.expect_redem_int <> n.expect_redem_int
        or o.inpwn_flg <> n.inpwn_flg
        or o.wdraw_way_cd <> n.wdraw_way_cd
        or o.acct_attr_cd <> n.acct_attr_cd
        or o.cntpty_acct_name <> n.cntpty_acct_name
        or o.potd_acct_id <> n.potd_acct_id
        or o.cds_int_accr_way_cd <> n.cds_int_accr_way_cd
        or o.subscr_acct_id <> n.subscr_acct_id
        or o.col_int_acct_id <> n.col_int_acct_id
        or o.del_dt <> n.del_dt
        or o.fail_rs_descb <> n.fail_rs_descb
        or o.memo <> n.memo
        or o.del_auth_teller_id <> n.del_auth_teller_id
        or o.del_teller_id <> n.del_teller_id
        or o.revo_dt <> n.revo_dt
        or o.dep_char_cd <> n.dep_char_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_cds_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,precon_rgst_acct_type -- 预约登记账户类型代码
    ,precon_org -- 预约机构编号
    ,precon_curr_cd -- 预约币种代码
    ,precon_amt -- 预约金额
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,comb_prod_id -- 组合产品编号
    ,acct_name -- 账户名称
    ,seq_num -- 序号
    ,on_acct_seq_num -- 挂账序号
    ,supp_on_acct_sub_seq_num -- 追加挂账子序号
    ,tran_amt -- 交易金额
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,pd_issue_amt -- 期次发行金额
    ,issue_year -- 发行年度
    ,issue_begin_dt -- 发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,chn_id -- 渠道编号
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_sub_acct_num -- 对手子账号
    ,cntpty_prod_id -- 对手产品编号
    ,lmt_id -- 限制编号
    ,vouch_no -- 凭证号码
    ,auto_payoff_flg -- 自动结清标志
    ,bank_int_int_rat -- 行内利率
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_set_day -- 结息日
    ,int_set_freq_cd -- 结息频率代码
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,next_int_set_dt -- 下一结息日期
    ,tran_ref_no -- 交易参考号
    ,teller_id -- 柜员编号
    ,acct_status_cd -- 账户状态代码
    ,redem_dt -- 赎回日期
    ,expect_redem_int -- 预计赎回利息
    ,inpwn_flg -- 质押标志
    ,wdraw_way_cd -- 支取方式代码
    ,acct_attr_cd -- 账户属性代码
    ,cntpty_acct_name -- 对手账户名称
    ,potd_acct_id -- 定期一本通账户编号
    ,cds_int_accr_way_cd -- 大额存单计息方式代码
    ,subscr_acct_id -- 认购账户编号
    ,col_int_acct_id -- 收息账户编号
    ,del_dt -- 删除日期
    ,fail_rs_descb -- 失败原因描述
    ,memo -- 摘要
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,revo_dt -- 撤单日期
    ,dep_char_cd -- 存款性质代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_cds_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,precon_id -- 预约编号
    ,precon_rgst_dt -- 预约登记日期
    ,precon_open_acct_dt -- 预约开户日期
    ,precon_rgst_acct_type -- 预约登记账户类型代码
    ,precon_org -- 预约机构编号
    ,precon_curr_cd -- 预约币种代码
    ,precon_amt -- 预约金额
    ,pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,cust_acct_num -- 客户账号
    ,curr_cd -- 币种代码
    ,sub_acct_num -- 子账号
    ,prod_id -- 产品编号
    ,comb_prod_id -- 组合产品编号
    ,acct_name -- 账户名称
    ,seq_num -- 序号
    ,on_acct_seq_num -- 挂账序号
    ,supp_on_acct_sub_seq_num -- 追加挂账子序号
    ,tran_amt -- 交易金额
    ,pd_cd -- 期次编号
    ,pd_prod_cate_cd -- 期次产品类别代码
    ,pd_issue_amt -- 期次发行金额
    ,issue_year -- 发行年度
    ,issue_begin_dt -- 发行起始日期
    ,issue_termnt_dt -- 发行终止日期
    ,chn_id -- 渠道编号
    ,cntpty_acct_id -- 对手账户编号
    ,cntpty_cust_acct_num -- 对手客户账号
    ,cntpty_acct_curr_cd -- 对手账户币种代码
    ,cntpty_sub_acct_num -- 对手子账号
    ,cntpty_prod_id -- 对手产品编号
    ,lmt_id -- 限制编号
    ,vouch_no -- 凭证号码
    ,auto_payoff_flg -- 自动结清标志
    ,bank_int_int_rat -- 行内利率
    ,exec_int_rat -- 执行利率
    ,float_int_rat -- 浮动利率
    ,int_rat_type_cd -- 利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_set_day -- 结息日
    ,int_set_freq_cd -- 结息频率代码
    ,accrd_freq_pay_int_flg -- 按频率付息标志
    ,next_int_set_dt -- 下一结息日期
    ,tran_ref_no -- 交易参考号
    ,teller_id -- 柜员编号
    ,acct_status_cd -- 账户状态代码
    ,redem_dt -- 赎回日期
    ,expect_redem_int -- 预计赎回利息
    ,inpwn_flg -- 质押标志
    ,wdraw_way_cd -- 支取方式代码
    ,acct_attr_cd -- 账户属性代码
    ,cntpty_acct_name -- 对手账户名称
    ,potd_acct_id -- 定期一本通账户编号
    ,cds_int_accr_way_cd -- 大额存单计息方式代码
    ,subscr_acct_id -- 认购账户编号
    ,col_int_acct_id -- 收息账户编号
    ,del_dt -- 删除日期
    ,fail_rs_descb -- 失败原因描述
    ,memo -- 摘要
    ,del_auth_teller_id -- 删除授权柜员编号
    ,del_teller_id -- 删除柜员编号
    ,revo_dt -- 撤单日期
    ,dep_char_cd -- 存款性质代码
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
    ,o.precon_rgst_dt -- 预约登记日期
    ,o.precon_open_acct_dt -- 预约开户日期
    ,o.precon_rgst_acct_type -- 预约登记账户类型代码
    ,o.precon_org -- 预约机构编号
    ,o.precon_curr_cd -- 预约币种代码
    ,o.precon_amt -- 预约金额
    ,o.pd_prod_precon_status_cd -- 期次产品预约状态代码
    ,o.cust_id -- 客户编号
    ,o.acct_id -- 账户编号
    ,o.cust_acct_num -- 客户账号
    ,o.curr_cd -- 币种代码
    ,o.sub_acct_num -- 子账号
    ,o.prod_id -- 产品编号
    ,o.comb_prod_id -- 组合产品编号
    ,o.acct_name -- 账户名称
    ,o.seq_num -- 序号
    ,o.on_acct_seq_num -- 挂账序号
    ,o.supp_on_acct_sub_seq_num -- 追加挂账子序号
    ,o.tran_amt -- 交易金额
    ,o.pd_cd -- 期次编号
    ,o.pd_prod_cate_cd -- 期次产品类别代码
    ,o.pd_issue_amt -- 期次发行金额
    ,o.issue_year -- 发行年度
    ,o.issue_begin_dt -- 发行起始日期
    ,o.issue_termnt_dt -- 发行终止日期
    ,o.chn_id -- 渠道编号
    ,o.cntpty_acct_id -- 对手账户编号
    ,o.cntpty_cust_acct_num -- 对手客户账号
    ,o.cntpty_acct_curr_cd -- 对手账户币种代码
    ,o.cntpty_sub_acct_num -- 对手子账号
    ,o.cntpty_prod_id -- 对手产品编号
    ,o.lmt_id -- 限制编号
    ,o.vouch_no -- 凭证号码
    ,o.auto_payoff_flg -- 自动结清标志
    ,o.bank_int_int_rat -- 行内利率
    ,o.exec_int_rat -- 执行利率
    ,o.float_int_rat -- 浮动利率
    ,o.int_rat_type_cd -- 利率类型代码
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_set_day -- 结息日
    ,o.int_set_freq_cd -- 结息频率代码
    ,o.accrd_freq_pay_int_flg -- 按频率付息标志
    ,o.next_int_set_dt -- 下一结息日期
    ,o.tran_ref_no -- 交易参考号
    ,o.teller_id -- 柜员编号
    ,o.acct_status_cd -- 账户状态代码
    ,o.redem_dt -- 赎回日期
    ,o.expect_redem_int -- 预计赎回利息
    ,o.inpwn_flg -- 质押标志
    ,o.wdraw_way_cd -- 支取方式代码
    ,o.acct_attr_cd -- 账户属性代码
    ,o.cntpty_acct_name -- 对手账户名称
    ,o.potd_acct_id -- 定期一本通账户编号
    ,o.cds_int_accr_way_cd -- 大额存单计息方式代码
    ,o.subscr_acct_id -- 认购账户编号
    ,o.col_int_acct_id -- 收息账户编号
    ,o.del_dt -- 删除日期
    ,o.fail_rs_descb -- 失败原因描述
    ,o.memo -- 摘要
    ,o.del_auth_teller_id -- 删除授权柜员编号
    ,o.del_teller_id -- 删除柜员编号
    ,o.revo_dt -- 撤单日期
    ,o.dep_char_cd -- 存款性质代码
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
from ${iml_schema}.agt_cds_h_ncbsf1_bk o
    left join ${iml_schema}.agt_cds_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.precon_id = n.precon_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_cds_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.precon_id = d.precon_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_cds_h;
--alter table ${iml_schema}.agt_cds_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_cds_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_cds_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_cds_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_cds_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_cds_h_ncbsf1_cl;
alter table ${iml_schema}.agt_cds_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_cds_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_cds_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_cds_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_cds_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_cds_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_cds_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_cds_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
