/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icp_inv_ctrl_plat_dep_tran_dtl
CreateDate: 20230404
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl(
etl_dt date --数据日期
,chn varchar2(10) --渠道
,dtl_seq_num varchar2(60) --明细序号
,acct_name varchar2(500) --账户名称
,tran_type varchar2(30) --交易类型
,debit_crdt_flg varchar2(10) --借贷标志
,curr varchar2(10) --币种
,tran_amt number(30,2) --交易金额
,tran_bal number(30,2) --交易余额
,tran_dt date --交易日期
,tran_tm varchar2(30) --交易时间
,tran_flow_num varchar2(60) --交易流水号
,tran_cntpty_name varchar2(250) --交易对方名称
,tran_cntpty_acct_num varchar2(60) --交易对方账号
,tran_cntpty_acct_open_bank varchar2(60) --交易对方账号开户行
,tran_memo varchar2(500) --交易摘要
,tran_brac_name varchar2(200) --交易网点名称
,tran_brac_cd varchar2(60) --交易网点代码
,tran_brac_addr varchar2(500) --交易网点地址
,vouch_kind varchar2(60) --凭证种类
,vouch_num varchar2(60) --凭证号
,cash_flg varchar2(10) --现金标志
,termn_no varchar2(60) --终端号
,tran_is_sucs varchar2(30) --交易是否成功
,ip_addr varchar2(250) --IP地址
,mac_addr varchar2(60) --MAC地址
,tran_teller_no varchar2(60) --交易柜员号
,remark varchar2(250) --备注
,acct_seq_num varchar2(60) --账户序号
,cert_type_cd varchar2(10) --证件类型代码
,cert_no varchar2(60) --证件号码
,open_acct_org varchar2(60) --开户机构
,acct_num varchar2(60) --账号
,rev_tran_flg varchar2(10) --反交易标志
,revs_tran_idf varchar2(10) --冲正交易标识
,auth_teller_no varchar2(60) --授权柜员号
,public_agent_phone varchar2(60) --代办人联系电话
,public_agent_name varchar2(400) --
,public_agent_cert_no varchar2(60) --代办人证件号码
,public_agent_cert_type varchar2(10) --代办人证件类型
,job_cd varchar2(10) -- 任务代码
,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl is '查控平台存款账户交易明细';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.etl_dt is '数据日期';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.chn is '渠道';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.dtl_seq_num is '明细序号';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.acct_name is '账户名称';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_type is '交易类型';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.debit_crdt_flg is '借贷标志';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.curr is '币种';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_amt is '交易金额';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_bal is '交易余额';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_dt is '交易日期';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_tm is '交易时间';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_flow_num is '交易流水号';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_cntpty_name is '交易对方名称';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_cntpty_acct_num is '交易对方账号';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_cntpty_acct_open_bank is '交易对方账号开户行';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_memo is '交易摘要';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_brac_name is '交易网点名称';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_brac_cd is '交易网点代码';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_brac_addr is '交易网点地址';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.vouch_kind is '凭证种类';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.vouch_num is '凭证号';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.cash_flg is '现金标志';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.termn_no is '终端号';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_is_sucs is '交易是否成功';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.ip_addr is 'IP地址';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.mac_addr is 'MAC地址';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.tran_teller_no is '交易柜员号';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.remark is '备注';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.acct_seq_num is '账户序号';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.cert_no is '证件号码';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.open_acct_org is '开户机构';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.acct_num is '账号';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.rev_tran_flg is '反交易标志';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.revs_tran_idf is '冲正交易标识';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.auth_teller_no is '授权柜员号';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.public_agent_phone is '代办人联系电话';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.public_agent_name is '';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.public_agent_cert_no is '代办人证件号码';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.public_agent_cert_type is '代办人证件类型';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.job_cd is '任务代码';
comment on column ${idl_schema}.icp_inv_ctrl_plat_dep_tran_dtl.etl_timestamp is 'ETL处理时间戳';
