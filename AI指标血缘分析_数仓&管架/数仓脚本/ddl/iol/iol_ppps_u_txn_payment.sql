/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_u_txn_payment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_u_txn_payment
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_u_txn_payment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_u_txn_payment(
    sys_id varchar2(32) -- 系统流水
    ,sys_date varchar2(10) -- 交易日期
    ,trx_id varchar2(32) -- 交易流水号
    ,settlmt_dt varchar2(32) -- 清算日期
    ,acct_in_tp varchar2(32) -- 账户输入方式
    ,r_p_flg varchar2(10) -- 收／付标识
    ,trxtyp varchar2(4) -- 交易类型编码
    ,trx_trm_tp varchar2(64) -- 交易终端类型
    ,trx_trm_no varchar2(8) -- 交易终端编码
    ,trx_curry varchar2(5) -- 交易币种
    ,trx_amt_d number(20,2) -- 交易拆分后金额
    ,trx_amt varchar2(24) -- 交易金额
    ,biz_tp varchar2(8) -- 业务种类
    ,pyer_acct_issr_id varchar2(16) -- 付款方账户所属标识
    ,id_tp varchar2(10) -- 付款方证件类型
    ,id_no varchar2(20) -- 付款方证件号码
    ,sgn_no varchar2(55) -- 签约协议号
    ,pyer_acct_id varchar2(40) -- 付款方账户
    ,pyer_nm varchar2(500) -- 付款方名称
    ,pyee_issr_id varchar2(11) -- 发送机构标识
    ,pyee_acct_issr_id varchar2(16) -- 收款方账户所属标识
    ,pyee_acct_tp varchar2(10) -- 收款方账户类型
    ,pyee_acct_id varchar2(40) -- 收款方账户
    ,pyee_nm varchar2(500) -- 收款方名称
    ,instg_acct_id varchar2(40) -- 备付金银行账户
    ,instg_acct_nm varchar2(500) -- 备付金账户名称
    ,resfd_acct_issr_id varchar2(11) -- 备付金银行机构标识
    ,channel_issr_id varchar2(69) -- 渠道方机构标识
    ,product_tp varchar2(69) -- 产品类型
    ,product_ass_information varchar2(500) -- 产品辅助信息
    ,mrchnt_no varchar2(15) -- 商户编码
    ,mrchnt_tp_id varchar2(15) -- 商户类别
    ,mrchnt_pltfrm_nm varchar2(500) -- 商户名称
    ,sub_mrchnt_no varchar2(30) -- 二级商户编码
    ,sub_mrchnt_tp_id varchar2(15) -- 二级商户类别
    ,sub_mrchnt_pltfrm_nm varchar2(500) -- 二级商户名称
    ,device_mode varchar2(256) -- 设备型号
    ,device_language varchar2(3) -- 设备语言
    ,source_i_p varchar2(64) -- ip地址
    ,m_a_c varchar2(64) -- mac地址
    ,dev_id varchar2(129) -- 设备号
    ,extensive_device_location varchar2(32) -- gps位置
    ,device_number varchar2(32) -- sim卡号
    ,device_s_i_m_number varchar2(8) -- sim卡数量
    ,account_i_d_hash varchar2(64) -- 账户id
    ,risk_score varchar2(8) -- 风险评估
    ,risk_reason_code varchar2(500) -- 原因码
    ,mchnt_usr_rgstr_tm varchar2(14) -- 收单端用户注册日期
    ,mchnt_usr_rgstr_email varchar2(64) -- 收单端用户注册?氏涞刂?
    ,rcv_province varchar2(100) -- 收货省
    ,rcv_city varchar2(100) -- 收货市
    ,goods_class varchar2(2) -- 商品类型
    ,trx_status varchar2(8) -- 交易状态
    ,trx_dt_tm varchar2(20) -- 交易日期时间
    ,sys_rtn_cd varchar2(10) -- 系统返回码
    ,sys_rtn_desc varchar2(768) -- 系统返回说明
    ,host_id varchar2(32) -- 核心流水
    ,host_date varchar2(10) -- 核心日期
    ,host_status varchar2(8) -- 核心状态
    ,create_time varchar2(20) -- 创建时间
    ,update_time varchar2(20) -- 更新时间时间戳
    ,ordr_id varchar2(40) -- 订单号
    ,ordr_desc varchar2(1300) -- 订单详情
    ,sys_type varchar2(2) -- 系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心
    ,adjust_flag varchar2(1) -- 调账标识   0-未调账 1-已调账
    ,liqu_flag varchar2(1) -- 清算标识 0-未清算 1-已清算
    ,transfer_flag varchar2(1) -- 转移标识 0-未转移 1-已转移
    ,quick_chk varchar2(2) -- 对账状态
    ,host_check varchar2(2) -- 核心对账状态
    ,chk_status varchar2(2) -- 对账状态
    ,rs_flag varchar2(2) -- 来往账标识 1-往账 2-来账
    ,branch_no varchar2(8) -- 收款方所属分支机构号
    ,city_no varchar2(8) -- 收款方所属分行号
    ,branch_nm varchar2(64) -- 收款方所属分支机构名称
    ,txn_no varchar2(30) -- 平台交易流水号
    ,txn_date varchar2(8) -- 平台交易日期
    ,txn_time varchar2(6) -- 平台交易时间
    ,batch_id varchar2(20) -- 银联无卡交易：场次号（即批次号）
    ,settlmt_inf varchar2(20) -- 清算信息：xxyy,xx为文件序号，yy为场次号（即批次号）
    ,teller_no varchar2(8) -- 柜员号
    ,open_org_id varchar2(12) -- 开户机构编号
    ,tran_seq_no varchar2(32) -- 外联平台流水
    ,global_seq_no varchar2(32) -- 外联全局平台流水
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ppps_u_txn_payment to ${iml_schema};
grant select on ${iol_schema}.ppps_u_txn_payment to ${icl_schema};
grant select on ${iol_schema}.ppps_u_txn_payment to ${idl_schema};
grant select on ${iol_schema}.ppps_u_txn_payment to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_u_txn_payment is '贷记付款流水表';
comment on column ${iol_schema}.ppps_u_txn_payment.sys_id is '系统流水';
comment on column ${iol_schema}.ppps_u_txn_payment.sys_date is '交易日期';
comment on column ${iol_schema}.ppps_u_txn_payment.trx_id is '交易流水号';
comment on column ${iol_schema}.ppps_u_txn_payment.settlmt_dt is '清算日期';
comment on column ${iol_schema}.ppps_u_txn_payment.acct_in_tp is '账户输入方式';
comment on column ${iol_schema}.ppps_u_txn_payment.r_p_flg is '收／付标识';
comment on column ${iol_schema}.ppps_u_txn_payment.trxtyp is '交易类型编码';
comment on column ${iol_schema}.ppps_u_txn_payment.trx_trm_tp is '交易终端类型';
comment on column ${iol_schema}.ppps_u_txn_payment.trx_trm_no is '交易终端编码';
comment on column ${iol_schema}.ppps_u_txn_payment.trx_curry is '交易币种';
comment on column ${iol_schema}.ppps_u_txn_payment.trx_amt_d is '交易拆分后金额';
comment on column ${iol_schema}.ppps_u_txn_payment.trx_amt is '交易金额';
comment on column ${iol_schema}.ppps_u_txn_payment.biz_tp is '业务种类';
comment on column ${iol_schema}.ppps_u_txn_payment.pyer_acct_issr_id is '付款方账户所属标识';
comment on column ${iol_schema}.ppps_u_txn_payment.id_tp is '付款方证件类型';
comment on column ${iol_schema}.ppps_u_txn_payment.id_no is '付款方证件号码';
comment on column ${iol_schema}.ppps_u_txn_payment.sgn_no is '签约协议号';
comment on column ${iol_schema}.ppps_u_txn_payment.pyer_acct_id is '付款方账户';
comment on column ${iol_schema}.ppps_u_txn_payment.pyer_nm is '付款方名称';
comment on column ${iol_schema}.ppps_u_txn_payment.pyee_issr_id is '发送机构标识';
comment on column ${iol_schema}.ppps_u_txn_payment.pyee_acct_issr_id is '收款方账户所属标识';
comment on column ${iol_schema}.ppps_u_txn_payment.pyee_acct_tp is '收款方账户类型';
comment on column ${iol_schema}.ppps_u_txn_payment.pyee_acct_id is '收款方账户';
comment on column ${iol_schema}.ppps_u_txn_payment.pyee_nm is '收款方名称';
comment on column ${iol_schema}.ppps_u_txn_payment.instg_acct_id is '备付金银行账户';
comment on column ${iol_schema}.ppps_u_txn_payment.instg_acct_nm is '备付金账户名称';
comment on column ${iol_schema}.ppps_u_txn_payment.resfd_acct_issr_id is '备付金银行机构标识';
comment on column ${iol_schema}.ppps_u_txn_payment.channel_issr_id is '渠道方机构标识';
comment on column ${iol_schema}.ppps_u_txn_payment.product_tp is '产品类型';
comment on column ${iol_schema}.ppps_u_txn_payment.product_ass_information is '产品辅助信息';
comment on column ${iol_schema}.ppps_u_txn_payment.mrchnt_no is '商户编码';
comment on column ${iol_schema}.ppps_u_txn_payment.mrchnt_tp_id is '商户类别';
comment on column ${iol_schema}.ppps_u_txn_payment.mrchnt_pltfrm_nm is '商户名称';
comment on column ${iol_schema}.ppps_u_txn_payment.sub_mrchnt_no is '二级商户编码';
comment on column ${iol_schema}.ppps_u_txn_payment.sub_mrchnt_tp_id is '二级商户类别';
comment on column ${iol_schema}.ppps_u_txn_payment.sub_mrchnt_pltfrm_nm is '二级商户名称';
comment on column ${iol_schema}.ppps_u_txn_payment.device_mode is '设备型号';
comment on column ${iol_schema}.ppps_u_txn_payment.device_language is '设备语言';
comment on column ${iol_schema}.ppps_u_txn_payment.source_i_p is 'ip地址';
comment on column ${iol_schema}.ppps_u_txn_payment.m_a_c is 'mac地址';
comment on column ${iol_schema}.ppps_u_txn_payment.dev_id is '设备号';
comment on column ${iol_schema}.ppps_u_txn_payment.extensive_device_location is 'gps位置';
comment on column ${iol_schema}.ppps_u_txn_payment.device_number is 'sim卡号';
comment on column ${iol_schema}.ppps_u_txn_payment.device_s_i_m_number is 'sim卡数量';
comment on column ${iol_schema}.ppps_u_txn_payment.account_i_d_hash is '账户id';
comment on column ${iol_schema}.ppps_u_txn_payment.risk_score is '风险评估';
comment on column ${iol_schema}.ppps_u_txn_payment.risk_reason_code is '原因码';
comment on column ${iol_schema}.ppps_u_txn_payment.mchnt_usr_rgstr_tm is '收单端用户注册日期';
comment on column ${iol_schema}.ppps_u_txn_payment.mchnt_usr_rgstr_email is '收单端用户注册?氏涞刂?';
comment on column ${iol_schema}.ppps_u_txn_payment.rcv_province is '收货省';
comment on column ${iol_schema}.ppps_u_txn_payment.rcv_city is '收货市';
comment on column ${iol_schema}.ppps_u_txn_payment.goods_class is '商品类型';
comment on column ${iol_schema}.ppps_u_txn_payment.trx_status is '交易状态';
comment on column ${iol_schema}.ppps_u_txn_payment.trx_dt_tm is '交易日期时间';
comment on column ${iol_schema}.ppps_u_txn_payment.sys_rtn_cd is '系统返回码';
comment on column ${iol_schema}.ppps_u_txn_payment.sys_rtn_desc is '系统返回说明';
comment on column ${iol_schema}.ppps_u_txn_payment.host_id is '核心流水';
comment on column ${iol_schema}.ppps_u_txn_payment.host_date is '核心日期';
comment on column ${iol_schema}.ppps_u_txn_payment.host_status is '核心状态';
comment on column ${iol_schema}.ppps_u_txn_payment.create_time is '创建时间';
comment on column ${iol_schema}.ppps_u_txn_payment.update_time is '更新时间时间戳';
comment on column ${iol_schema}.ppps_u_txn_payment.ordr_id is '订单号';
comment on column ${iol_schema}.ppps_u_txn_payment.ordr_desc is '订单详情';
comment on column ${iol_schema}.ppps_u_txn_payment.sys_type is '系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心';
comment on column ${iol_schema}.ppps_u_txn_payment.adjust_flag is '调账标识   0-未调账 1-已调账';
comment on column ${iol_schema}.ppps_u_txn_payment.liqu_flag is '清算标识 0-未清算 1-已清算';
comment on column ${iol_schema}.ppps_u_txn_payment.transfer_flag is '转移标识 0-未转移 1-已转移';
comment on column ${iol_schema}.ppps_u_txn_payment.quick_chk is '对账状态';
comment on column ${iol_schema}.ppps_u_txn_payment.host_check is '核心对账状态';
comment on column ${iol_schema}.ppps_u_txn_payment.chk_status is '对账状态';
comment on column ${iol_schema}.ppps_u_txn_payment.rs_flag is '来往账标识 1-往账 2-来账';
comment on column ${iol_schema}.ppps_u_txn_payment.branch_no is '收款方所属分支机构号';
comment on column ${iol_schema}.ppps_u_txn_payment.city_no is '收款方所属分行号';
comment on column ${iol_schema}.ppps_u_txn_payment.branch_nm is '收款方所属分支机构名称';
comment on column ${iol_schema}.ppps_u_txn_payment.txn_no is '平台交易流水号';
comment on column ${iol_schema}.ppps_u_txn_payment.txn_date is '平台交易日期';
comment on column ${iol_schema}.ppps_u_txn_payment.txn_time is '平台交易时间';
comment on column ${iol_schema}.ppps_u_txn_payment.batch_id is '银联无卡交易：场次号（即批次号）';
comment on column ${iol_schema}.ppps_u_txn_payment.settlmt_inf is '清算信息：xxyy,xx为文件序号，yy为场次号（即批次号）';
comment on column ${iol_schema}.ppps_u_txn_payment.teller_no is '柜员号';
comment on column ${iol_schema}.ppps_u_txn_payment.open_org_id is '开户机构编号';
comment on column ${iol_schema}.ppps_u_txn_payment.tran_seq_no is '外联平台流水';
comment on column ${iol_schema}.ppps_u_txn_payment.global_seq_no is '外联全局平台流水';
comment on column ${iol_schema}.ppps_u_txn_payment.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ppps_u_txn_payment.etl_timestamp is 'ETL处理时间戳';
