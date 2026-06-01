/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fzss_mod_fzs_bookkeep_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fzss_mod_fzs_bookkeep_info
whenever sqlerror continue none;
drop table ${iol_schema}.fzss_mod_fzs_bookkeep_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_bookkeep_info(
    plat_date varchar2(8) -- 系统日期 yyyyMMdd
    ,plat_time varchar2(6) -- 系统时间 HHmmss
    ,plat_serial_no varchar2(60) -- 系统流水
    ,corp_work_date varchar2(8) -- 平台日期
    ,order_no varchar2(64) -- 订单号/子订单号
    ,corp_id varchar2(10) -- 平台商户号
    ,mybank varchar2(20) -- 法人标识代码
    ,zone_no varchar2(6) -- 分行号
    ,tran_type varchar2(3) -- 交易类型 [枚举: B01-支付订单充值, B02-支付订单充值撤销, B03-支付订单充值退款, B11-先用后付垫资, C01-分账请求, C02-分账退回, C03-补差申请, C05-白名单资金划拨, C06-功能户划拨, C07-白名单资金划拨退回, D01-提现, T01-退汇, T02-普通入账, T03-提现冲正]
    ,acct_no varchar2(40) -- 客户账号
    ,acct_name varchar2(256) -- 账户名称
    ,tran_amt number(20,2) -- 交易金额
    ,dc_flag varchar2(2) -- 借贷方向 [枚举: D-借,C-贷]
    ,reverse_flag varchar2(2) -- 被退汇标志 [枚举: 1：是（表示本记录被退汇） 2：否]
    ,to_acct_no varchar2(40) -- 对方账号
    ,to_acct_name varchar2(256) -- 对方户名
    ,effect_type varchar2(1) -- 影响余额类型 [枚举: 0-可提,1-待清算,2-冻结,]
    ,cal_flag varchar2(1) -- 更新余额标识 [枚举: 0-未更新,1-已更新]
    ,clear_status varchar2(1) -- 清算状态 [枚举: 0-未清算,1-已清算]
    ,clear_date varchar2(8) -- 清算日期
    ,abst_desc varchar2(500) -- 摘要描述
    ,tellerno varchar2(15) -- 柜员号
    ,brno varchar2(6) -- 机构号
    ,fund_date varchar2(8) -- 退汇系统日期
    ,fund_serial_no varchar2(64) -- 退汇系统流水号
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
grant select on ${iol_schema}.fzss_mod_fzs_bookkeep_info to ${iml_schema};
grant select on ${iol_schema}.fzss_mod_fzs_bookkeep_info to ${icl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_bookkeep_info to ${idl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_bookkeep_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fzss_mod_fzs_bookkeep_info is '簿记台账表';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.plat_date is '系统日期 yyyyMMdd';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.plat_time is '系统时间 HHmmss';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.plat_serial_no is '系统流水';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.corp_work_date is '平台日期';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.order_no is '订单号/子订单号';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.corp_id is '平台商户号';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.mybank is '法人标识代码';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.zone_no is '分行号';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.tran_type is '交易类型 [枚举: B01-支付订单充值, B02-支付订单充值撤销, B03-支付订单充值退款, B11-先用后付垫资, C01-分账请求, C02-分账退回, C03-补差申请, C05-白名单资金划拨, C06-功能户划拨, C07-白名单资金划拨退回, D01-提现, T01-退汇, T02-普通入账, T03-提现冲正]';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.acct_no is '客户账号';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.acct_name is '账户名称';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.tran_amt is '交易金额';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.dc_flag is '借贷方向 [枚举: D-借,C-贷]';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.reverse_flag is '被退汇标志 [枚举: 1：是（表示本记录被退汇） 2：否]';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.to_acct_no is '对方账号';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.to_acct_name is '对方户名';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.effect_type is '影响余额类型 [枚举: 0-可提,1-待清算,2-冻结,]';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.cal_flag is '更新余额标识 [枚举: 0-未更新,1-已更新]';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.clear_status is '清算状态 [枚举: 0-未清算,1-已清算]';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.clear_date is '清算日期';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.abst_desc is '摘要描述';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.tellerno is '柜员号';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.brno is '机构号';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.fund_date is '退汇系统日期';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.fund_serial_no is '退汇系统流水号';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.remark is '备注';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.error_code is '返回码 [枚举: 0为成功，其他为失败]';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.error_msg is '返回信息';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.start_dt is '开始时间';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.end_dt is '结束时间';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.id_mark is '增删标志';
comment on column ${iol_schema}.fzss_mod_fzs_bookkeep_info.etl_timestamp is 'ETL处理时间戳';
