/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_mem_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_mem_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_mem_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_mem_info(
    id varchar2(60) -- 主键ID
    ,mem_no varchar2(9) -- 渠道代码
    ,mem_type varchar2(6) -- 渠道类别： MT01 银行 MT02 非银行 MT03 资管类 MT04 存托类 MT05 供应链平台 MT06 B2B平台
    ,mem_name varchar2(450) -- 渠道名称
    ,mem_status varchar2(6) -- 渠道状态： ST01 活动 ST02 禁用
    ,mem_bank_no varchar2(18) -- 大额支付系统行号
    ,clear_mode varchar2(9) -- 清算模式:  CLE001 模式一(人行清算账户) CLE002 模式二(票交所资金账户-法人会员)  CLE003 模式三(票交所资金账户-资管类会员)
    ,is_clear_check varchar2(2) -- 是否开通结算确认
    ,settle_confirm varchar2(2) -- 财务公司ECDS线上清算权限： 1 有 2 无
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,social_credit_no varchar2(27) -- 统一社会信用代码
    ,bank_authy_type varchar2(6) -- 票据业务系统上线开关： ST00 票据业务系统未上线 ST01 票据业务系统已上线不可拆分票据 ST02 票据业务系统已上线可拆分票据
    ,batch_clearing_switch varchar2(6) -- 批量清算开关： 00 关闭 01 开启
    ,create_by varchar2(12) -- 创建人
    ,create_time varchar2(12) -- 创建时间
    ,last_upd_opr varchar2(12) -- 最后操作人
    ,msg_upd_time varchar2(21) -- 报文更新时间
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
grant select on ${iol_schema}.bdms_mem_info to ${iml_schema};
grant select on ${iol_schema}.bdms_mem_info to ${icl_schema};
grant select on ${iol_schema}.bdms_mem_info to ${idl_schema};
grant select on ${iol_schema}.bdms_mem_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_mem_info is '成员信息表';
comment on column ${iol_schema}.bdms_mem_info.id is '主键ID';
comment on column ${iol_schema}.bdms_mem_info.mem_no is '渠道代码';
comment on column ${iol_schema}.bdms_mem_info.mem_type is '渠道类别： MT01 银行 MT02 非银行 MT03 资管类 MT04 存托类 MT05 供应链平台 MT06 B2B平台';
comment on column ${iol_schema}.bdms_mem_info.mem_name is '渠道名称';
comment on column ${iol_schema}.bdms_mem_info.mem_status is '渠道状态： ST01 活动 ST02 禁用';
comment on column ${iol_schema}.bdms_mem_info.mem_bank_no is '大额支付系统行号';
comment on column ${iol_schema}.bdms_mem_info.clear_mode is '清算模式:  CLE001 模式一(人行清算账户) CLE002 模式二(票交所资金账户-法人会员)  CLE003 模式三(票交所资金账户-资管类会员)';
comment on column ${iol_schema}.bdms_mem_info.is_clear_check is '是否开通结算确认';
comment on column ${iol_schema}.bdms_mem_info.settle_confirm is '财务公司ECDS线上清算权限： 1 有 2 无';
comment on column ${iol_schema}.bdms_mem_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_mem_info.social_credit_no is '统一社会信用代码';
comment on column ${iol_schema}.bdms_mem_info.bank_authy_type is '票据业务系统上线开关： ST00 票据业务系统未上线 ST01 票据业务系统已上线不可拆分票据 ST02 票据业务系统已上线可拆分票据';
comment on column ${iol_schema}.bdms_mem_info.batch_clearing_switch is '批量清算开关： 00 关闭 01 开启';
comment on column ${iol_schema}.bdms_mem_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_mem_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_mem_info.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_mem_info.msg_upd_time is '报文更新时间';
comment on column ${iol_schema}.bdms_mem_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_mem_info.etl_timestamp is 'ETL处理时间戳';
