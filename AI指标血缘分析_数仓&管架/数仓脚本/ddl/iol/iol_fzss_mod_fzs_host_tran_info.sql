/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fzss_mod_fzs_host_tran_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fzss_mod_fzs_host_tran_info
whenever sqlerror continue none;
drop table ${iol_schema}.fzss_mod_fzs_host_tran_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_host_tran_info(
    plat_date varchar2(8) -- 系统日期 yyyyMMdd
    ,plat_time varchar2(6) -- 系统时间 HHmmss
    ,plat_serial_no varchar2(60) -- 系统流水
    ,channel_no varchar2(20) -- 渠道编号 3位英文系统编号,如FZS,PPP
    ,mybank varchar2(20) -- 法人标识代码
    ,zone_no varchar2(6) -- 分行号
    ,tellerno varchar2(15) -- 柜员号
    ,brno varchar2(6) -- 机构号
    ,corp_id varchar2(10) -- 平台商户号
    ,global_serial_no varchar2(60) -- 全局流水号
    ,corp_work_date varchar2(8) -- 平台订单日期
    ,order_no varchar2(64) -- 订单号
    ,plat_tran_type varchar2(3) -- 平台交易类型 [枚举: D01-提现,T01-退汇,T02-普通入账]
    ,acct_no varchar2(40) -- 交易账号
    ,acct_name varchar2(256) -- 账户名称
    ,currency varchar2(5) -- 币种
    ,tran_amt number(20,2) -- 交易金额
    ,revtranf varchar2(1) -- 正反交易标志(0-正交易,1-冲正交易,) [枚举: 反交易标志(0-正交易,1-冲正交易,)]
    ,dc_flag varchar2(2) -- 借贷方向 [枚举: D-借,C-贷]
    ,to_acct_no varchar2(40) -- 对方账号
    ,to_acct_name varchar2(256) -- 对方户名
    ,to_final_inst_code varchar2(16) -- 对方金融机构代码
    ,to_final_inst_name varchar2(256) -- 对方金融机构名称
    ,cnaps_branch_id varchar2(16) -- 联行号
    ,bank_flag varchar2(1) -- 行内外标志 [枚举: 1-行内,2-行外]
    ,abst_code varchar2(20) -- 摘要码
    ,abst_desc varchar2(500) -- 摘要描述
    ,ppp_check_code varchar2(30) -- ppp对账代码
    ,ppp_srv_cllpty_trx_seq varchar2(64) -- 记账系统内流水号
    ,ppp_status varchar2(1) -- 记账平台状态 [枚举: 9-待处理,0-成功,1-失败,2-异常,3-处理中,]
    ,ppp_code varchar2(60) -- 记账结果代码
    ,ppp_msg varchar2(1024) -- 记账结果信息
    ,ppp_date varchar2(8) -- 记账平台交易日期
    ,ppp_time varchar2(6) -- 记账平台交易时间
    ,ppp_serial_no varchar2(64) -- 记账平台交易流水号
    ,ppp_chnl_encd varchar2(6) -- ppp通道编码
    ,ppp_seq_no varchar2(60) -- 记账平台交易序号
    ,host_date varchar2(8) -- 核心交易日期
    ,host_time varchar2(16) -- 核心交易时间
    ,host_serial_no varchar2(64) -- 核心交易流水号
    ,check_status varchar2(1) -- 对账状态 [枚举: 0-未对账,1-已对账]
    ,is_check_deal varchar2(1) -- 是否差错处理 [枚举: 0-否,1-是]
    ,fund_flag varchar2(2) -- 退汇标识 [枚举: 0-未退汇,1-已退汇,]
    ,fund_date varchar2(8) -- 退汇通知日期
    ,fund_serial_no varchar2(60) -- 退汇通知流水
    ,fund_reason varchar2(250) -- 退汇原因
    ,reversal_flag varchar2(1) -- 冲正标识
    ,reversal_date varchar2(8) -- 冲正日期
    ,reversal_serial_no varchar2(64) -- 冲正流水号
    ,remark varchar2(600) -- 备注
    ,error_code varchar2(60) -- 返回码 [枚举: 0为成功，其他为失败]
    ,error_msg varchar2(1024) -- 返回信息
    ,create_timestamp timestamp -- 创建时间戳
    ,update_timestamp timestamp -- 更新时间戳
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fzss_mod_fzs_host_tran_info to ${iml_schema};
grant select on ${iol_schema}.fzss_mod_fzs_host_tran_info to ${icl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_host_tran_info to ${idl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_host_tran_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fzss_mod_fzs_host_tran_info is '核心交易明细信息表';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.plat_date is '系统日期 yyyyMMdd';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.plat_time is '系统时间 HHmmss';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.plat_serial_no is '系统流水';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.channel_no is '渠道编号 3位英文系统编号,如FZS,PPP';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.mybank is '法人标识代码';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.zone_no is '分行号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.tellerno is '柜员号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.brno is '机构号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.corp_id is '平台商户号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.global_serial_no is '全局流水号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.corp_work_date is '平台订单日期';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.order_no is '订单号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.plat_tran_type is '平台交易类型 [枚举: D01-提现,T01-退汇,T02-普通入账]';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.acct_no is '交易账号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.acct_name is '账户名称';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.currency is '币种';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.tran_amt is '交易金额';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.revtranf is '正反交易标志(0-正交易,1-冲正交易,) [枚举: 反交易标志(0-正交易,1-冲正交易,)]';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.dc_flag is '借贷方向 [枚举: D-借,C-贷]';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.to_acct_no is '对方账号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.to_acct_name is '对方户名';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.to_final_inst_code is '对方金融机构代码';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.to_final_inst_name is '对方金融机构名称';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.cnaps_branch_id is '联行号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.bank_flag is '行内外标志 [枚举: 1-行内,2-行外]';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.abst_code is '摘要码';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.abst_desc is '摘要描述';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.ppp_check_code is 'ppp对账代码';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.ppp_srv_cllpty_trx_seq is '记账系统内流水号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.ppp_status is '记账平台状态 [枚举: 9-待处理,0-成功,1-失败,2-异常,3-处理中,]';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.ppp_code is '记账结果代码';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.ppp_msg is '记账结果信息';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.ppp_date is '记账平台交易日期';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.ppp_time is '记账平台交易时间';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.ppp_serial_no is '记账平台交易流水号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.ppp_chnl_encd is 'ppp通道编码';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.ppp_seq_no is '记账平台交易序号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.host_date is '核心交易日期';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.host_time is '核心交易时间';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.host_serial_no is '核心交易流水号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.check_status is '对账状态 [枚举: 0-未对账,1-已对账]';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.is_check_deal is '是否差错处理 [枚举: 0-否,1-是]';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.fund_flag is '退汇标识 [枚举: 0-未退汇,1-已退汇,]';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.fund_date is '退汇通知日期';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.fund_serial_no is '退汇通知流水';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.fund_reason is '退汇原因';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.reversal_flag is '冲正标识';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.reversal_date is '冲正日期';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.reversal_serial_no is '冲正流水号';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.remark is '备注';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.error_code is '返回码 [枚举: 0为成功，其他为失败]';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.error_msg is '返回信息';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.start_dt is '开始时间';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.end_dt is '结束时间';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.id_mark is '增删标志';
comment on column ${iol_schema}.fzss_mod_fzs_host_tran_info.etl_timestamp is 'ETL处理时间戳';
