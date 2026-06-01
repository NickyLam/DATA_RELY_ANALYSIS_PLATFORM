/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_payment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_payment
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_payment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_payment(
    payment_id number -- 支付ID
    ,aspclient_id number -- 部门ID
    ,dealsconfirm_id number -- 交易确认ID
    ,deal_tablename varchar2(45) -- 交易表名
    ,deal_id number -- 交易表对应记录ID
    ,eventtype varchar2(5) -- 事件类型
    ,sequence number -- 序列号
    ,payment_id_prev number -- 前一个支付ID
    ,keepfolder_id number -- 账户ID
    ,assettype varchar2(60) -- 资产类型
    ,buztype varchar2(60) -- 交易类型
    ,dealtype varchar2(60) -- 作业类型
    ,actiontype varchar2(60) -- 操作类型
    ,releasedate number -- 发布日期
    ,generatedate number -- 生成日期
    ,settledate number -- 交割日期
    ,cpty_id number -- 交易对手ID
    ,cpty_name varchar2(192) -- 交易对手名称
    ,payreceivetype varchar2(2) -- 收付类型
    ,settlecurrency varchar2(5) -- 交割币种
    ,settleamount number -- 交割金额
    ,securitycode varchar2(48) -- 债券交割代码
    ,quantity number -- 交割债券
    ,act_settledate number -- 实际结算日期
    ,act_settlecurrency varchar2(5) -- 实际交割币种
    ,act_settleamount number -- 实际结算金额
    ,act_securitycode varchar2(48) -- 实际交割债券代码
    ,act_quantity number -- 实际交割债券
    ,pstatus varchar2(3) -- 状态
    ,lastmodified timestamp -- 最后修改日期
    ,users_id_modifier number -- 变更用户ID
    ,settlemethod varchar2(5) -- 交割方式
    ,act_settlemethod varchar2(5) -- 实际交割方式
    ,act_advance_amount number -- 暂未启用
    ,note varchar2(600) -- 备注
    ,act_principal number -- 实际本金
    ,act_interest number -- 实际利息
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
grant select on ${iol_schema}.ctms_tbs_v_payment to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_payment to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_payment to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_payment to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_payment is '实际收付确认';
comment on column ${iol_schema}.ctms_tbs_v_payment.payment_id is '支付ID';
comment on column ${iol_schema}.ctms_tbs_v_payment.aspclient_id is '部门ID';
comment on column ${iol_schema}.ctms_tbs_v_payment.dealsconfirm_id is '交易确认ID';
comment on column ${iol_schema}.ctms_tbs_v_payment.deal_tablename is '交易表名';
comment on column ${iol_schema}.ctms_tbs_v_payment.deal_id is '交易表对应记录ID';
comment on column ${iol_schema}.ctms_tbs_v_payment.eventtype is '事件类型';
comment on column ${iol_schema}.ctms_tbs_v_payment.sequence is '序列号';
comment on column ${iol_schema}.ctms_tbs_v_payment.payment_id_prev is '前一个支付ID';
comment on column ${iol_schema}.ctms_tbs_v_payment.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_v_payment.assettype is '资产类型';
comment on column ${iol_schema}.ctms_tbs_v_payment.buztype is '交易类型';
comment on column ${iol_schema}.ctms_tbs_v_payment.dealtype is '作业类型';
comment on column ${iol_schema}.ctms_tbs_v_payment.actiontype is '操作类型';
comment on column ${iol_schema}.ctms_tbs_v_payment.releasedate is '发布日期';
comment on column ${iol_schema}.ctms_tbs_v_payment.generatedate is '生成日期';
comment on column ${iol_schema}.ctms_tbs_v_payment.settledate is '交割日期';
comment on column ${iol_schema}.ctms_tbs_v_payment.cpty_id is '交易对手ID';
comment on column ${iol_schema}.ctms_tbs_v_payment.cpty_name is '交易对手名称';
comment on column ${iol_schema}.ctms_tbs_v_payment.payreceivetype is '收付类型';
comment on column ${iol_schema}.ctms_tbs_v_payment.settlecurrency is '交割币种';
comment on column ${iol_schema}.ctms_tbs_v_payment.settleamount is '交割金额';
comment on column ${iol_schema}.ctms_tbs_v_payment.securitycode is '债券交割代码';
comment on column ${iol_schema}.ctms_tbs_v_payment.quantity is '交割债券';
comment on column ${iol_schema}.ctms_tbs_v_payment.act_settledate is '实际结算日期';
comment on column ${iol_schema}.ctms_tbs_v_payment.act_settlecurrency is '实际交割币种';
comment on column ${iol_schema}.ctms_tbs_v_payment.act_settleamount is '实际结算金额';
comment on column ${iol_schema}.ctms_tbs_v_payment.act_securitycode is '实际交割债券代码';
comment on column ${iol_schema}.ctms_tbs_v_payment.act_quantity is '实际交割债券';
comment on column ${iol_schema}.ctms_tbs_v_payment.pstatus is '状态';
comment on column ${iol_schema}.ctms_tbs_v_payment.lastmodified is '最后修改日期';
comment on column ${iol_schema}.ctms_tbs_v_payment.users_id_modifier is '变更用户ID';
comment on column ${iol_schema}.ctms_tbs_v_payment.settlemethod is '交割方式';
comment on column ${iol_schema}.ctms_tbs_v_payment.act_settlemethod is '实际交割方式';
comment on column ${iol_schema}.ctms_tbs_v_payment.act_advance_amount is '暂未启用';
comment on column ${iol_schema}.ctms_tbs_v_payment.note is '备注';
comment on column ${iol_schema}.ctms_tbs_v_payment.act_principal is '实际本金';
comment on column ${iol_schema}.ctms_tbs_v_payment.act_interest is '实际利息';
comment on column ${iol_schema}.ctms_tbs_v_payment.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_payment.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_payment.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_payment.etl_timestamp is 'ETL处理时间戳';
