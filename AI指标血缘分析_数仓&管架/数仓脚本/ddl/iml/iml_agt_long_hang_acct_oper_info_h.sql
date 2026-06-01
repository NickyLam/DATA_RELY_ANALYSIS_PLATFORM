/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_long_hang_acct_oper_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_long_hang_acct_oper_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_long_hang_acct_oper_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_long_hang_acct_oper_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,bus_batch_no varchar2(60) -- 业务批次号
    ,turn_long_hang_oper_type_cd varchar2(30) -- 转久悬操作类型代码
    ,manual_imp_flg varchar2(10) -- 手工导入标志
    ,cust_id varchar2(100) -- 客户编号
    ,cust_acct_num varchar2(60) -- 客户账号
    ,prod_id varchar2(100) -- 产品编号
    ,curr_cd varchar2(30) -- 币种代码
    ,sub_acct_num varchar2(60) -- 子账号
    ,acct_name varchar2(500) -- 账户名称
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,bal number(30,2) -- 余额
    ,int_amt number(30,2) -- 利息金额
    ,acct_pric_int_sum number(30,2) -- 账户本息合计
    ,acct_int_tax number(30,2) -- 账户利息税
    ,prep_turn_long_hang_org_id varchar2(100) -- 待转久悬机构编号
    ,prep_turn_long_hang_oper_teller_id varchar2(100) -- 待转久悬操作柜员编号
    ,prep_turn_long_hang_dt date -- 待转久悬日期
    ,prep_turn_out_bus_dt date -- 待转营业外日期
    ,prep_turn_out_bus_oper_teller_id varchar2(100) -- 待转营业外操作柜员编号
    ,long_hang_clean_dt date -- 久悬清理日期
    ,long_hang_clean_org_id varchar2(100) -- 久悬清理机构编号
    ,tran_out_teller_id varchar2(100) -- 转出柜员编号
    ,tran_out_long_hang_rs varchar2(500) -- 转出久悬原因
    ,long_hang_status_cd varchar2(30) -- 久悬状态代码
    ,turn_long_hang_dt date -- 转久悬日期
    ,turn_long_hang_org_id varchar2(100) -- 转久悬机构编号
    ,turn_long_hang_teller_id varchar2(100) -- 转久悬柜员编号
    ,tran_in_long_hang_rs varchar2(500) -- 转入久悬原因
    ,acct_actv_dt date -- 账户激活日期
    ,actv_org_id varchar2(100) -- 激活机构编号
    ,actv_teller_id varchar2(100) -- 激活柜员编号
    ,turn_out_bus_dt date -- 转营业外日期
    ,turn_out_bus_oper_teller_id varchar2(100) -- 转营业外操作柜员编号
    ,priv_flg varchar2(10) -- 对私标志
    ,tran_out_acct_num_obank_flg varchar2(10) -- 转出账号他行标志
    ,tran_out_acct_id varchar2(100) -- 转出账户编号
    ,aim_curr_cd varchar2(30) -- 目的币种代码
    ,tran_out_acct_sub_acct_num varchar2(60) -- 转出账户子账号
    ,tran_out_acct_name varchar2(500) -- 转出账户名称
    ,tran_in_acct_type_cd varchar2(30) -- 转入账户类型代码
    ,addit_remark varchar2(500) -- 附加备注
    ,tran_tm timestamp -- 交易时间
    ,actl_enter_acct_amt number(30,2) -- 实际入账金额
    ,tran_dt date -- 交易日期
    ,tran_org_id varchar2(100) -- 交易机构编号
    ,tran_teller_id varchar2(100) -- 交易柜员编号
    ,tran_amt number(30,2) -- 交易金额
    ,tran_ref_no varchar2(60) -- 交易参考号
    ,auth_teller_id varchar2(100) -- 授权柜员编号
    ,chn_id varchar2(100) -- 渠道编号
    ,edit_id varchar2(100) -- 版本编号
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
grant select on ${iml_schema}.agt_long_hang_acct_oper_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_long_hang_acct_oper_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_long_hang_acct_oper_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_long_hang_acct_oper_info_h is '久悬户操作信息历史';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.bus_batch_no is '业务批次号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.turn_long_hang_oper_type_cd is '转久悬操作类型代码';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.manual_imp_flg is '手工导入标志';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.cust_id is '客户编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.cust_acct_num is '客户账号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.sub_acct_num is '子账号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.acct_name is '账户名称';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.bal is '余额';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.int_amt is '利息金额';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.acct_pric_int_sum is '账户本息合计';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.acct_int_tax is '账户利息税';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.prep_turn_long_hang_org_id is '待转久悬机构编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.prep_turn_long_hang_oper_teller_id is '待转久悬操作柜员编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.prep_turn_long_hang_dt is '待转久悬日期';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.prep_turn_out_bus_dt is '待转营业外日期';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.prep_turn_out_bus_oper_teller_id is '待转营业外操作柜员编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.long_hang_clean_dt is '久悬清理日期';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.long_hang_clean_org_id is '久悬清理机构编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_out_teller_id is '转出柜员编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_out_long_hang_rs is '转出久悬原因';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.long_hang_status_cd is '久悬状态代码';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.turn_long_hang_dt is '转久悬日期';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.turn_long_hang_org_id is '转久悬机构编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.turn_long_hang_teller_id is '转久悬柜员编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_in_long_hang_rs is '转入久悬原因';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.acct_actv_dt is '账户激活日期';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.actv_org_id is '激活机构编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.actv_teller_id is '激活柜员编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.turn_out_bus_dt is '转营业外日期';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.turn_out_bus_oper_teller_id is '转营业外操作柜员编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.priv_flg is '对私标志';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_out_acct_num_obank_flg is '转出账号他行标志';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_out_acct_id is '转出账户编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.aim_curr_cd is '目的币种代码';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_out_acct_sub_acct_num is '转出账户子账号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_out_acct_name is '转出账户名称';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_in_acct_type_cd is '转入账户类型代码';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.addit_remark is '附加备注';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_tm is '交易时间';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.actl_enter_acct_amt is '实际入账金额';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_dt is '交易日期';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_org_id is '交易机构编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_teller_id is '交易柜员编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_amt is '交易金额';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.tran_ref_no is '交易参考号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.auth_teller_id is '授权柜员编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.chn_id is '渠道编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.edit_id is '版本编号';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_long_hang_acct_oper_info_h.etl_timestamp is 'ETL处理时间戳';
