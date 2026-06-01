/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_putout_online
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_putout_online
whenever sqlerror continue none;
drop table ${iol_schema}.icms_putout_online purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_putout_online(
    putoutno varchar2(32) -- 出账流水号
    ,contractserialno varchar2(32) -- 合同号
    ,hostnbr varchar2(32) -- 信保转账交易流水
    ,dd_status varchar2(1) -- 放款状态
    ,hostdate varchar2(8) -- 信保转账交易日期
    ,firstpayamt number(24,6) -- 首付款金额
    ,migtflag varchar2(80) -- 
    ,channel varchar2(10) -- 渠道号
    ,isfirstpay varchar2(2) -- 是否首付款1是2否
    ,firstpayratio number(24,6) -- 首付款比例%
    ,duebillserialno varchar2(40) -- 借据号
    ,billamt number(24,6) -- 服务费
    ,oarateexaresult varchar2(1) -- OA利率审批结果 0 不通过 1 通过1
    ,orderno varchar2(40) -- 订单号
    ,ordersumamt number(24,6) -- 订单金额
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
grant select on ${iol_schema}.icms_putout_online to ${iml_schema};
grant select on ${iol_schema}.icms_putout_online to ${icl_schema};
grant select on ${iol_schema}.icms_putout_online to ${idl_schema};
grant select on ${iol_schema}.icms_putout_online to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_putout_online is '线上放款申请记录';
comment on column ${iol_schema}.icms_putout_online.putoutno is '出账流水号';
comment on column ${iol_schema}.icms_putout_online.contractserialno is '合同号';
comment on column ${iol_schema}.icms_putout_online.hostnbr is '信保转账交易流水';
comment on column ${iol_schema}.icms_putout_online.dd_status is '放款状态';
comment on column ${iol_schema}.icms_putout_online.hostdate is '信保转账交易日期';
comment on column ${iol_schema}.icms_putout_online.firstpayamt is '首付款金额';
comment on column ${iol_schema}.icms_putout_online.migtflag is '';
comment on column ${iol_schema}.icms_putout_online.channel is '渠道号';
comment on column ${iol_schema}.icms_putout_online.isfirstpay is '是否首付款1是2否';
comment on column ${iol_schema}.icms_putout_online.firstpayratio is '首付款比例%';
comment on column ${iol_schema}.icms_putout_online.duebillserialno is '借据号';
comment on column ${iol_schema}.icms_putout_online.billamt is '服务费';
comment on column ${iol_schema}.icms_putout_online.oarateexaresult is 'OA利率审批结果 0 不通过 1 通过1';
comment on column ${iol_schema}.icms_putout_online.orderno is '订单号';
comment on column ${iol_schema}.icms_putout_online.ordersumamt is '订单金额';
comment on column ${iol_schema}.icms_putout_online.start_dt is '开始时间';
comment on column ${iol_schema}.icms_putout_online.end_dt is '结束时间';
comment on column ${iol_schema}.icms_putout_online.id_mark is '增删标志';
comment on column ${iol_schema}.icms_putout_online.etl_timestamp is 'ETL处理时间戳';
