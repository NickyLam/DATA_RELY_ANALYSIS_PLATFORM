/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_u_txn_refund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_u_txn_refund
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_u_txn_refund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_u_txn_refund(
    sys_id varchar2(32) -- 系统流水
    ,sys_date varchar2(10) -- 系统日期
    ,trx_id varchar2(50) -- 退款流水号
    ,trx_dt_tm varchar2(20) -- 交易日期时间
    ,settlmt_dt varchar2(32) -- 清算日期
    ,trxtyp varchar2(4) -- 交易类型编码
    ,trx_curry varchar2(5) -- 退款币种
    ,trx_amt varchar2(20) -- 交易金额
    ,trx_amt_d number(19,2) -- 退款金额
    ,acct_in_tp varchar2(2) -- 账户输入方式
    ,trx_trm_tp varchar2(2) -- 交易终端类型
    ,trx_trm_no varchar2(8) -- 交易终端编码
    ,r_p_flg varchar2(1) -- 收／付标识
    ,pyee_acct_issr_id varchar2(20) -- 收款方账户所属机构标识
    ,pyee_acct_id varchar2(34) -- 收款方账户编号
    ,pyee_acct_tp varchar2(4) -- 收款方账户类型
    ,pyee_issr_id varchar2(16) -- 发送机构标识
    ,pyer_acct_issr_id varchar2(16) -- 付款方账户所属机构标识
    ,resfd_acct_issr_id varchar2(16) -- 备付金银行机构标识
    ,instg_acct_id varchar2(34) -- 备付金银行账号
    ,instg_acct_nm varchar2(500) -- 备付金银行账户名称
    ,channel_issr_id varchar2(69) -- 渠道方机构标识
    ,sgn_no varchar2(55) -- 签约协议号
    ,mrchnt_no varchar2(15) -- 商户编号
    ,mrchnt_tp_id varchar2(4) -- 商户类别
    ,mrchnt_pltfrm_nm varchar2(500) -- 商户名称
    ,sub_mrchnt_no varchar2(30) -- 二级商户编码
    ,sub_mrchnt_tp_id varchar2(4) -- 二级商户类别
    ,sub_mrchnt_pltfrm_nm varchar2(500) -- 二级商户名称
    ,ori_trx_id varchar2(50) -- 原交易流水号
    ,ori_trx_amt varchar2(20) -- 原交易金额
    ,ori_trx_amt_d number(19,2) -- 原订单金额
    ,ori_ordr_id varchar2(40) -- 原订单号
    ,ori_trx_dt_tm varchar2(20) -- 原交易日期时间
    ,product_tp varchar2(8) -- 0
    ,product_ass_information varchar2(500) -- 原产品辅助信息
    ,device_mode varchar2(256) -- 设备型号
    ,device_language varchar2(3) -- 设备语言:代码遵从iso639-3标准
    ,source_i_p varchar2(64) -- ip地址
    ,m_a_c varchar2(64) -- mac地址
    ,dev_id varchar2(129) -- 设备号
    ,extensive_device_location varchar2(32) -- gps位置:经纬度
    ,device_number varchar2(32) -- sim卡号码,存储11位手机号码,存在2个通讯设备号码,则用逗号隔开
    ,device_s_i_m_number varchar2(8) -- 设备sim卡数量
    ,account_i_d_hash varchar2(64) -- 账户id
    ,risk_score varchar2(8) -- 风险评分:0-1000分
    ,risk_reason_code varchar2(500) -- 原因码
    ,mchnt_usr_rgstr_tm varchar2(14) -- 收单端用户注册日期,14位时间字符yyyymmddhhmmss
    ,mchnt_usr_rgstr_email varchar2(64) -- 收单端注册账户邮箱地址
    ,rcv_province varchar2(100) -- 收货省,注意需转换为银联清算地区代码
    ,rcv_city varchar2(100) -- 收货市,注意需转换为银联清算地区代码
    ,goods_class varchar2(2) -- 商品类型:虚拟(1),非虚拟(2),不确定(0)
    ,pyer_acct_id varchar2(40) -- 退款方账户编号
    ,pyer_acct_tp varchar2(4) -- 退款方账户类型
    ,pyee_nm varchar2(500) -- 收款方账户名称
    ,trx_status varchar2(8) -- 交易状态
    ,sys_rtn_cd varchar2(10) -- 系统返回码
    ,sys_rtn_desc varchar2(768) -- 系统返回说明
    ,host_id varchar2(32) -- 核心流水
    ,host_date varchar2(10) -- 核心日期
    ,host_status varchar2(8) -- 核心状态
    ,create_time varchar2(20) -- 创建日期时间
    ,update_time varchar2(20) -- 修改日期时间
    ,sys_type varchar2(2) -- 系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心
    ,adjust_flag varchar2(1) -- 调账标识   0-未调账 1-已调账
    ,liqu_flag varchar2(1) -- 清算标识 0-未清算 1-已清算
    ,transfer_flag varchar2(1) -- 转移标识 0-未转移 1-已转移
    ,quick_chk varchar2(2) -- 银联状态
    ,host_check varchar2(2) -- 核心对账状态
    ,chk_status varchar2(2) -- 对账状态
    ,trans_type varchar2(64) -- refund
    ,rs_flag varchar2(2) -- 来往账标识 1-往账 2-来账
    ,branch_no varchar2(8) -- 收款方所属分支机构号
    ,city_no varchar2(8) -- 收款方所属分行号
    ,branch_nm varchar2(64) -- 收款方所属分支机构名称
    ,settlmt_inf varchar2(20) -- 清算信息：xxyy,xx为文件序号，yy为场次号（即批次号）
    ,batch_id varchar2(20) -- 银联无卡交易：场次号（即批次号）
    ,txn_no varchar2(30) -- 平台交易流水号
    ,txn_date varchar2(8) -- 平台交易日期
    ,txn_time varchar2(6) -- 平台交易时间
    ,teller_no varchar2(8) -- 柜员号
    ,open_org_id varchar2(12) -- 开户机构编号
    ,tran_seq_no varchar2(32) -- 外联平台流水
    ,global_seq_no varchar2(32) -- 外联全局平台流水
    ,mrchnt_border_in varchar2(8) -- 商户境内外标识
    ,mrchnt_cntry_cd varchar2(64) -- 商户国家和地区代码
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
grant select on ${iol_schema}.ppps_u_txn_refund to ${iml_schema};
grant select on ${iol_schema}.ppps_u_txn_refund to ${icl_schema};
grant select on ${iol_schema}.ppps_u_txn_refund to ${idl_schema};
grant select on ${iol_schema}.ppps_u_txn_refund to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_u_txn_refund is '退款流水表';
comment on column ${iol_schema}.ppps_u_txn_refund.sys_id is '系统流水';
comment on column ${iol_schema}.ppps_u_txn_refund.sys_date is '系统日期';
comment on column ${iol_schema}.ppps_u_txn_refund.trx_id is '退款流水号';
comment on column ${iol_schema}.ppps_u_txn_refund.trx_dt_tm is '交易日期时间';
comment on column ${iol_schema}.ppps_u_txn_refund.settlmt_dt is '清算日期';
comment on column ${iol_schema}.ppps_u_txn_refund.trxtyp is '交易类型编码';
comment on column ${iol_schema}.ppps_u_txn_refund.trx_curry is '退款币种';
comment on column ${iol_schema}.ppps_u_txn_refund.trx_amt is '交易金额';
comment on column ${iol_schema}.ppps_u_txn_refund.trx_amt_d is '退款金额';
comment on column ${iol_schema}.ppps_u_txn_refund.acct_in_tp is '账户输入方式';
comment on column ${iol_schema}.ppps_u_txn_refund.trx_trm_tp is '交易终端类型';
comment on column ${iol_schema}.ppps_u_txn_refund.trx_trm_no is '交易终端编码';
comment on column ${iol_schema}.ppps_u_txn_refund.r_p_flg is '收／付标识';
comment on column ${iol_schema}.ppps_u_txn_refund.pyee_acct_issr_id is '收款方账户所属机构标识';
comment on column ${iol_schema}.ppps_u_txn_refund.pyee_acct_id is '收款方账户编号';
comment on column ${iol_schema}.ppps_u_txn_refund.pyee_acct_tp is '收款方账户类型';
comment on column ${iol_schema}.ppps_u_txn_refund.pyee_issr_id is '发送机构标识';
comment on column ${iol_schema}.ppps_u_txn_refund.pyer_acct_issr_id is '付款方账户所属机构标识';
comment on column ${iol_schema}.ppps_u_txn_refund.resfd_acct_issr_id is '备付金银行机构标识';
comment on column ${iol_schema}.ppps_u_txn_refund.instg_acct_id is '备付金银行账号';
comment on column ${iol_schema}.ppps_u_txn_refund.instg_acct_nm is '备付金银行账户名称';
comment on column ${iol_schema}.ppps_u_txn_refund.channel_issr_id is '渠道方机构标识';
comment on column ${iol_schema}.ppps_u_txn_refund.sgn_no is '签约协议号';
comment on column ${iol_schema}.ppps_u_txn_refund.mrchnt_no is '商户编号';
comment on column ${iol_schema}.ppps_u_txn_refund.mrchnt_tp_id is '商户类别';
comment on column ${iol_schema}.ppps_u_txn_refund.mrchnt_pltfrm_nm is '商户名称';
comment on column ${iol_schema}.ppps_u_txn_refund.sub_mrchnt_no is '二级商户编码';
comment on column ${iol_schema}.ppps_u_txn_refund.sub_mrchnt_tp_id is '二级商户类别';
comment on column ${iol_schema}.ppps_u_txn_refund.sub_mrchnt_pltfrm_nm is '二级商户名称';
comment on column ${iol_schema}.ppps_u_txn_refund.ori_trx_id is '原交易流水号';
comment on column ${iol_schema}.ppps_u_txn_refund.ori_trx_amt is '原交易金额';
comment on column ${iol_schema}.ppps_u_txn_refund.ori_trx_amt_d is '原订单金额';
comment on column ${iol_schema}.ppps_u_txn_refund.ori_ordr_id is '原订单号';
comment on column ${iol_schema}.ppps_u_txn_refund.ori_trx_dt_tm is '原交易日期时间';
comment on column ${iol_schema}.ppps_u_txn_refund.product_tp is '0';
comment on column ${iol_schema}.ppps_u_txn_refund.product_ass_information is '原产品辅助信息';
comment on column ${iol_schema}.ppps_u_txn_refund.device_mode is '设备型号';
comment on column ${iol_schema}.ppps_u_txn_refund.device_language is '设备语言:代码遵从iso639-3标准';
comment on column ${iol_schema}.ppps_u_txn_refund.source_i_p is 'ip地址';
comment on column ${iol_schema}.ppps_u_txn_refund.m_a_c is 'mac地址';
comment on column ${iol_schema}.ppps_u_txn_refund.dev_id is '设备号';
comment on column ${iol_schema}.ppps_u_txn_refund.extensive_device_location is 'gps位置:经纬度';
comment on column ${iol_schema}.ppps_u_txn_refund.device_number is 'sim卡号码,存储11位手机号码,存在2个通讯设备号码,则用逗号隔开';
comment on column ${iol_schema}.ppps_u_txn_refund.device_s_i_m_number is '设备sim卡数量';
comment on column ${iol_schema}.ppps_u_txn_refund.account_i_d_hash is '账户id';
comment on column ${iol_schema}.ppps_u_txn_refund.risk_score is '风险评分:0-1000分';
comment on column ${iol_schema}.ppps_u_txn_refund.risk_reason_code is '原因码';
comment on column ${iol_schema}.ppps_u_txn_refund.mchnt_usr_rgstr_tm is '收单端用户注册日期,14位时间字符yyyymmddhhmmss';
comment on column ${iol_schema}.ppps_u_txn_refund.mchnt_usr_rgstr_email is '收单端注册账户邮箱地址';
comment on column ${iol_schema}.ppps_u_txn_refund.rcv_province is '收货省,注意需转换为银联清算地区代码';
comment on column ${iol_schema}.ppps_u_txn_refund.rcv_city is '收货市,注意需转换为银联清算地区代码';
comment on column ${iol_schema}.ppps_u_txn_refund.goods_class is '商品类型:虚拟(1),非虚拟(2),不确定(0)';
comment on column ${iol_schema}.ppps_u_txn_refund.pyer_acct_id is '退款方账户编号';
comment on column ${iol_schema}.ppps_u_txn_refund.pyer_acct_tp is '退款方账户类型';
comment on column ${iol_schema}.ppps_u_txn_refund.pyee_nm is '收款方账户名称';
comment on column ${iol_schema}.ppps_u_txn_refund.trx_status is '交易状态';
comment on column ${iol_schema}.ppps_u_txn_refund.sys_rtn_cd is '系统返回码';
comment on column ${iol_schema}.ppps_u_txn_refund.sys_rtn_desc is '系统返回说明';
comment on column ${iol_schema}.ppps_u_txn_refund.host_id is '核心流水';
comment on column ${iol_schema}.ppps_u_txn_refund.host_date is '核心日期';
comment on column ${iol_schema}.ppps_u_txn_refund.host_status is '核心状态';
comment on column ${iol_schema}.ppps_u_txn_refund.create_time is '创建日期时间';
comment on column ${iol_schema}.ppps_u_txn_refund.update_time is '修改日期时间';
comment on column ${iol_schema}.ppps_u_txn_refund.sys_type is '系统类型  00：借记卡核心  01：贷记卡核心  02：互联网核心';
comment on column ${iol_schema}.ppps_u_txn_refund.adjust_flag is '调账标识   0-未调账 1-已调账';
comment on column ${iol_schema}.ppps_u_txn_refund.liqu_flag is '清算标识 0-未清算 1-已清算';
comment on column ${iol_schema}.ppps_u_txn_refund.transfer_flag is '转移标识 0-未转移 1-已转移';
comment on column ${iol_schema}.ppps_u_txn_refund.quick_chk is '银联状态';
comment on column ${iol_schema}.ppps_u_txn_refund.host_check is '核心对账状态';
comment on column ${iol_schema}.ppps_u_txn_refund.chk_status is '对账状态';
comment on column ${iol_schema}.ppps_u_txn_refund.trans_type is 'refund';
comment on column ${iol_schema}.ppps_u_txn_refund.rs_flag is '来往账标识 1-往账 2-来账';
comment on column ${iol_schema}.ppps_u_txn_refund.branch_no is '收款方所属分支机构号';
comment on column ${iol_schema}.ppps_u_txn_refund.city_no is '收款方所属分行号';
comment on column ${iol_schema}.ppps_u_txn_refund.branch_nm is '收款方所属分支机构名称';
comment on column ${iol_schema}.ppps_u_txn_refund.settlmt_inf is '清算信息：xxyy,xx为文件序号，yy为场次号（即批次号）';
comment on column ${iol_schema}.ppps_u_txn_refund.batch_id is '银联无卡交易：场次号（即批次号）';
comment on column ${iol_schema}.ppps_u_txn_refund.txn_no is '平台交易流水号';
comment on column ${iol_schema}.ppps_u_txn_refund.txn_date is '平台交易日期';
comment on column ${iol_schema}.ppps_u_txn_refund.txn_time is '平台交易时间';
comment on column ${iol_schema}.ppps_u_txn_refund.teller_no is '柜员号';
comment on column ${iol_schema}.ppps_u_txn_refund.open_org_id is '开户机构编号';
comment on column ${iol_schema}.ppps_u_txn_refund.tran_seq_no is '外联平台流水';
comment on column ${iol_schema}.ppps_u_txn_refund.global_seq_no is '外联全局平台流水';
comment on column ${iol_schema}.ppps_u_txn_refund.mrchnt_border_in is '商户境内外标识';
comment on column ${iol_schema}.ppps_u_txn_refund.mrchnt_cntry_cd is '商户国家和地区代码';
comment on column ${iol_schema}.ppps_u_txn_refund.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ppps_u_txn_refund.etl_timestamp is 'ETL处理时间戳';
