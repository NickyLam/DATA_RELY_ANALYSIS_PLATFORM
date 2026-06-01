/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_cds_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_cds_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_cds_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_cds_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,precon_id varchar2(100) -- 预约编号
    ,precon_rgst_dt date -- 预约登记日期
    ,precon_open_acct_dt date -- 预约开户日期
    ,precon_rgst_acct_type varchar2(30) -- 预约登记账户类型代码
    ,precon_org varchar2(100) -- 预约机构编号
    ,precon_curr_cd varchar2(30) -- 预约币种代码
    ,precon_amt number(30,2) -- 预约金额
    ,pd_prod_precon_status_cd varchar2(30) -- 期次产品预约状态代码
    ,cust_id varchar2(100) -- 客户编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,curr_cd varchar2(30) -- 币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,prod_id varchar2(100) -- 产品编号
    ,comb_prod_id varchar2(250) -- 组合产品编号
    ,acct_name varchar2(500) -- 账户名称
    ,seq_num varchar2(60) -- 序号
    ,on_acct_seq_num varchar2(60) -- 挂账序号
    ,supp_on_acct_sub_seq_num varchar2(60) -- 追加挂账子序号
    ,tran_amt number(30,2) -- 交易金额
    ,pd_cd varchar2(30) -- 期次编号
    ,pd_prod_cate_cd varchar2(30) -- 期次产品类别代码
    ,pd_issue_amt number(30,2) -- 期次发行金额
    ,issue_year varchar2(60) -- 发行年度
    ,issue_begin_dt date -- 发行起始日期
    ,issue_termnt_dt date -- 发行终止日期
    ,chn_id varchar2(100) -- 渠道编号
    ,cntpty_acct_id varchar2(100) -- 对手账户编号
    ,cntpty_cust_acct_num varchar2(60) -- 对手客户账号
    ,cntpty_acct_curr_cd varchar2(30) -- 对手账户币种代码
    ,cntpty_sub_acct_num varchar2(60) -- 对手子账号
    ,cntpty_prod_id varchar2(100) -- 对手产品编号
    ,lmt_id varchar2(100) -- 限制编号
    ,vouch_no varchar2(60) -- 凭证号码
    ,auto_payoff_flg varchar2(10) -- 自动结清标志
    ,bank_int_int_rat number(18,8) -- 行内利率
    ,exec_int_rat number(18,8) -- 执行利率
    ,float_int_rat number(18,8) -- 浮动利率
    ,int_rat_type_cd varchar2(30) -- 利率类型代码
    ,int_rat_adj_way_cd varchar2(30) -- 利率调整方式代码
    ,int_set_day number(10) -- 结息日
    ,int_set_freq_cd varchar2(30) -- 结息频率代码
    ,accrd_freq_pay_int_flg varchar2(10) -- 按频率付息标志
    ,next_int_set_dt date -- 下一结息日期
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,teller_id varchar2(100) -- 柜员编号
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,redem_dt date -- 赎回日期
    ,expect_redem_int number(30,2) -- 预计赎回利息
    ,inpwn_flg varchar2(10) -- 质押标志
    ,wdraw_way_cd varchar2(30) -- 支取方式代码
    ,acct_attr_cd varchar2(30) -- 账户属性代码
    ,cntpty_acct_name varchar2(500) -- 对手账户名称
    ,potd_acct_id varchar2(100) -- 定期一本通账户编号
    ,cds_int_accr_way_cd varchar2(30) -- 大额存单计息方式代码
    ,subscr_acct_id varchar2(100) -- 认购账户编号
    ,col_int_acct_id varchar2(100) -- 收息账户编号
    ,del_dt date -- 删除日期
    ,fail_rs_descb varchar2(2000) -- 失败原因描述
    ,memo varchar2(2000) -- 摘要
    ,del_auth_teller_id varchar2(100) -- 删除授权柜员编号
    ,del_teller_id varchar2(100) -- 删除柜员编号
    ,revo_dt date -- 撤单日期
    ,dep_char_cd varchar2(30) -- 存款性质代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.agt_cds_h to ${icl_schema};
grant select on ${iml_schema}.agt_cds_h to ${idl_schema};
grant select on ${iml_schema}.agt_cds_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_cds_h is '大额存单历史';
comment on column ${iml_schema}.agt_cds_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_cds_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_cds_h.precon_id is '预约编号';
comment on column ${iml_schema}.agt_cds_h.precon_rgst_dt is '预约登记日期';
comment on column ${iml_schema}.agt_cds_h.precon_open_acct_dt is '预约开户日期';
comment on column ${iml_schema}.agt_cds_h.precon_rgst_acct_type is '预约登记账户类型代码';
comment on column ${iml_schema}.agt_cds_h.precon_org is '预约机构编号';
comment on column ${iml_schema}.agt_cds_h.precon_curr_cd is '预约币种代码';
comment on column ${iml_schema}.agt_cds_h.precon_amt is '预约金额';
comment on column ${iml_schema}.agt_cds_h.pd_prod_precon_status_cd is '期次产品预约状态代码';
comment on column ${iml_schema}.agt_cds_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_cds_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_cds_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_cds_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_cds_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_cds_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_cds_h.comb_prod_id is '组合产品编号';
comment on column ${iml_schema}.agt_cds_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_cds_h.seq_num is '序号';
comment on column ${iml_schema}.agt_cds_h.on_acct_seq_num is '挂账序号';
comment on column ${iml_schema}.agt_cds_h.supp_on_acct_sub_seq_num is '追加挂账子序号';
comment on column ${iml_schema}.agt_cds_h.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_cds_h.pd_cd is '期次编号';
comment on column ${iml_schema}.agt_cds_h.pd_prod_cate_cd is '期次产品类别代码';
comment on column ${iml_schema}.agt_cds_h.pd_issue_amt is '期次发行金额';
comment on column ${iml_schema}.agt_cds_h.issue_year is '发行年度';
comment on column ${iml_schema}.agt_cds_h.issue_begin_dt is '发行起始日期';
comment on column ${iml_schema}.agt_cds_h.issue_termnt_dt is '发行终止日期';
comment on column ${iml_schema}.agt_cds_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_cds_h.cntpty_acct_id is '对手账户编号';
comment on column ${iml_schema}.agt_cds_h.cntpty_cust_acct_num is '对手客户账号';
comment on column ${iml_schema}.agt_cds_h.cntpty_acct_curr_cd is '对手账户币种代码';
comment on column ${iml_schema}.agt_cds_h.cntpty_sub_acct_num is '对手子账号';
comment on column ${iml_schema}.agt_cds_h.cntpty_prod_id is '对手产品编号';
comment on column ${iml_schema}.agt_cds_h.lmt_id is '限制编号';
comment on column ${iml_schema}.agt_cds_h.vouch_no is '凭证号码';
comment on column ${iml_schema}.agt_cds_h.auto_payoff_flg is '自动结清标志';
comment on column ${iml_schema}.agt_cds_h.bank_int_int_rat is '行内利率';
comment on column ${iml_schema}.agt_cds_h.exec_int_rat is '执行利率';
comment on column ${iml_schema}.agt_cds_h.float_int_rat is '浮动利率';
comment on column ${iml_schema}.agt_cds_h.int_rat_type_cd is '利率类型代码';
comment on column ${iml_schema}.agt_cds_h.int_rat_adj_way_cd is '利率调整方式代码';
comment on column ${iml_schema}.agt_cds_h.int_set_day is '结息日';
comment on column ${iml_schema}.agt_cds_h.int_set_freq_cd is '结息频率代码';
comment on column ${iml_schema}.agt_cds_h.accrd_freq_pay_int_flg is '按频率付息标志';
comment on column ${iml_schema}.agt_cds_h.next_int_set_dt is '下一结息日期';
comment on column ${iml_schema}.agt_cds_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_cds_h.teller_id is '柜员编号';
comment on column ${iml_schema}.agt_cds_h.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.agt_cds_h.redem_dt is '赎回日期';
comment on column ${iml_schema}.agt_cds_h.expect_redem_int is '预计赎回利息';
comment on column ${iml_schema}.agt_cds_h.inpwn_flg is '质押标志';
comment on column ${iml_schema}.agt_cds_h.wdraw_way_cd is '支取方式代码';
comment on column ${iml_schema}.agt_cds_h.acct_attr_cd is '账户属性代码';
comment on column ${iml_schema}.agt_cds_h.cntpty_acct_name is '对手账户名称';
comment on column ${iml_schema}.agt_cds_h.potd_acct_id is '定期一本通账户编号';
comment on column ${iml_schema}.agt_cds_h.cds_int_accr_way_cd is '大额存单计息方式代码';
comment on column ${iml_schema}.agt_cds_h.subscr_acct_id is '认购账户编号';
comment on column ${iml_schema}.agt_cds_h.col_int_acct_id is '收息账户编号';
comment on column ${iml_schema}.agt_cds_h.del_dt is '删除日期';
comment on column ${iml_schema}.agt_cds_h.fail_rs_descb is '失败原因描述';
comment on column ${iml_schema}.agt_cds_h.memo is '摘要';
comment on column ${iml_schema}.agt_cds_h.del_auth_teller_id is '删除授权柜员编号';
comment on column ${iml_schema}.agt_cds_h.del_teller_id is '删除柜员编号';
comment on column ${iml_schema}.agt_cds_h.revo_dt is '撤单日期';
comment on column ${iml_schema}.agt_cds_h.dep_char_cd is '存款性质代码';
comment on column ${iml_schema}.agt_cds_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_cds_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_cds_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_cds_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_cds_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_cds_h.etl_timestamp is 'ETL处理时间戳';
