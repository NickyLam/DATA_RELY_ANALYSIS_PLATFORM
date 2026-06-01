/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncts_bt_acp_acceptmain_new
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new(
    tradeserno varchar2(16) -- 预受理编号
    ,oldtradeserno varchar2(16) -- 原预受理编号
    ,biztype varchar2(10) -- 业务类型
    ,status varchar2(6) -- 状态
    ,busiserno varchar2(50) -- 交易流水
    ,channelcode varchar2(20) -- 发起渠道
    ,acctno varchar2(32) -- 账号
    ,acctname varchar2(100) -- 户名
    ,custno varchar2(32) -- 客户号
    ,custname varchar2(500) -- 客户名称
    ,idtype varchar2(10) -- 证件类型
    ,idno varchar2(32) -- 证据号码
    ,idname varchar2(100) -- 证件名称
    ,is_porxy varchar2(2) -- 是否代理(0-否,1-是)
    ,agentidtype varchar2(10) -- 代理人证件类型
    ,agentidno varchar2(32) -- 代理人证件号码
    ,agentidname varchar2(100) -- 代理人证件名称
    ,agentphone varchar2(15) -- 代理人联系方式
    ,remark varchar2(1000) -- 备注|预审结论
    ,createdate date -- 创建日期
    ,createtime varchar2(6) -- 创建时间
    ,createby varchar2(50) -- 创建柜员
    ,updatedate date -- 更新日期
    ,updatetime varchar2(6) -- 更新时间
    ,updateby varchar2(50) -- 更新柜员
    ,reftradeserno varchar2(32) -- 流程银行受理流水号
    ,applydate varchar2(8) -- 申请日期
    ,applybrno varchar2(20) -- 申请机构
    ,phone varchar2(20) -- 手机号码
    ,reserv_id varchar2(40) -- 预约编号
    ,apply_remark varchar2(10) -- 提现用途及理由
    ,other_remark varchar2(500) -- 其他用途
    ,vouchers varchar2(100) -- 券别
    ,vouchers_amt varchar2(500) -- 券别金额
    ,apply_ccy varchar2(20) -- 币种
    ,apply_amt varchar2(32) -- 提现金额
    ,apply_type varchar2(2) -- 交易类型（2对公单位，1个人）
    ,etl_dt date -- ETL处理日期
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
grant select on ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new is '大额现金预受理表';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.tradeserno is '预受理编号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.oldtradeserno is '原预受理编号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.biztype is '业务类型';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.status is '状态';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.busiserno is '交易流水';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.channelcode is '发起渠道';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.acctno is '账号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.acctname is '户名';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.custno is '客户号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.custname is '客户名称';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.idtype is '证件类型';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.idno is '证据号码';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.idname is '证件名称';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.is_porxy is '是否代理(0-否,1-是)';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.agentidtype is '代理人证件类型';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.agentidno is '代理人证件号码';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.agentidname is '代理人证件名称';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.agentphone is '代理人联系方式';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.remark is '备注|预审结论';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.createdate is '创建日期';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.createtime is '创建时间';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.createby is '创建柜员';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.updatedate is '更新日期';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.updatetime is '更新时间';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.updateby is '更新柜员';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.reftradeserno is '流程银行受理流水号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.applydate is '申请日期';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.applybrno is '申请机构';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.phone is '手机号码';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.reserv_id is '预约编号';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.apply_remark is '提现用途及理由';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.other_remark is '其他用途';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.vouchers is '券别';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.vouchers_amt is '券别金额';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.apply_ccy is '币种';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.apply_amt is '提现金额';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.apply_type is '交易类型（2对公单位，1个人）';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ncts_bt_acp_acceptmain_new.etl_timestamp is 'ETL处理时间戳';