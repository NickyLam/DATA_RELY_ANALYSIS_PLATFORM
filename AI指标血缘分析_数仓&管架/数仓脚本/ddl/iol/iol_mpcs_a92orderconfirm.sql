/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a92orderconfirm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a92orderconfirm
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a92orderconfirm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92orderconfirm(
    filena varchar2(75) -- 文件名
    ,dtlseqid varchar2(12) -- 序号
    ,brokeruserid varchar2(45) -- 用户账户id
    ,accountid varchar2(96) -- 盈米账户id
    ,brokerorderno varchar2(96) -- 订单流水号
    ,orderid varchar2(120) -- 盈米订单号
    ,paymentmethodid varchar2(96) -- 支付方式id
    ,ordercreatedon varchar2(24) -- 下单时间
    ,ordertradedate varchar2(15) -- 订单交易日
    ,orderconfirmdate varchar2(15) -- 订单确认日
    ,fundcode varchar2(96) -- 基金代码
    ,sharetype varchar2(6) -- 收费类型a-前端收费  b-后端收费 c-c类收费
    ,busitype varchar2(18) -- 业务类型022-申购020-认购024-赎回036-转换039-定投申购029-修改分红方式134-非交易过户转入确认135-非交易过户转出确认142-强制赎回144-强行调增145-强行调减
    ,destfundcode varchar2(96) -- 转入基金代码
    ,destsharetype varchar2(6) -- 转入基金收费类型
    ,tradeamount varchar2(24) -- 申请金额
    ,tradeshare varchar2(30) -- 申请份额
    ,tradestat varchar2(6) -- 支付状态
    ,confirmstat varchar2(6) -- 确认状态
    ,orderdetail varchar2(383) -- 订单详情
    ,succamount varchar2(24) -- 成功金额
    ,succshare varchar2(30) -- 成功份额
    ,succinamount varchar2(24) -- 转入成功金额
    ,succinshare varchar2(30) -- 转入成功份额
    ,totfee varchar2(24) -- 总手续费
    ,taconfirmid varchar2(48) -- ta确认流水号
    ,pocode varchar2(96) -- 组合代码
    ,errmsg varchar2(383) -- 错误信息
    ,accountdate varchar2(15) -- 资金到账日期
    ,tradenav varchar2(15) -- 成交净值
    ,destnav varchar2(15) -- 目标基金成交净值
    ,status varchar2(2) -- 状态
    ,reserve1 varchar2(192) -- 备用字段1
    ,reserve2 varchar2(192) -- 备用字段2
    ,reserve3 varchar2(384) -- 备用字段3
    ,reserve4 varchar2(384) -- 备用字段4
    ,reserve5 varchar2(384) -- 备用字段5
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
grant select on ${iol_schema}.mpcs_a92orderconfirm to ${iml_schema};
grant select on ${iol_schema}.mpcs_a92orderconfirm to ${icl_schema};
grant select on ${iol_schema}.mpcs_a92orderconfirm to ${idl_schema};
grant select on ${iol_schema}.mpcs_a92orderconfirm to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a92orderconfirm is '盈米订单确认表';
comment on column ${iol_schema}.mpcs_a92orderconfirm.filena is '文件名';
comment on column ${iol_schema}.mpcs_a92orderconfirm.dtlseqid is '序号';
comment on column ${iol_schema}.mpcs_a92orderconfirm.brokeruserid is '用户账户id';
comment on column ${iol_schema}.mpcs_a92orderconfirm.accountid is '盈米账户id';
comment on column ${iol_schema}.mpcs_a92orderconfirm.brokerorderno is '订单流水号';
comment on column ${iol_schema}.mpcs_a92orderconfirm.orderid is '盈米订单号';
comment on column ${iol_schema}.mpcs_a92orderconfirm.paymentmethodid is '支付方式id';
comment on column ${iol_schema}.mpcs_a92orderconfirm.ordercreatedon is '下单时间';
comment on column ${iol_schema}.mpcs_a92orderconfirm.ordertradedate is '订单交易日';
comment on column ${iol_schema}.mpcs_a92orderconfirm.orderconfirmdate is '订单确认日';
comment on column ${iol_schema}.mpcs_a92orderconfirm.fundcode is '基金代码';
comment on column ${iol_schema}.mpcs_a92orderconfirm.sharetype is '收费类型a-前端收费  b-后端收费 c-c类收费';
comment on column ${iol_schema}.mpcs_a92orderconfirm.busitype is '业务类型022-申购020-认购024-赎回036-转换039-定投申购029-修改分红方式134-非交易过户转入确认135-非交易过户转出确认142-强制赎回144-强行调增145-强行调减';
comment on column ${iol_schema}.mpcs_a92orderconfirm.destfundcode is '转入基金代码';
comment on column ${iol_schema}.mpcs_a92orderconfirm.destsharetype is '转入基金收费类型';
comment on column ${iol_schema}.mpcs_a92orderconfirm.tradeamount is '申请金额';
comment on column ${iol_schema}.mpcs_a92orderconfirm.tradeshare is '申请份额';
comment on column ${iol_schema}.mpcs_a92orderconfirm.tradestat is '支付状态';
comment on column ${iol_schema}.mpcs_a92orderconfirm.confirmstat is '确认状态';
comment on column ${iol_schema}.mpcs_a92orderconfirm.orderdetail is '订单详情';
comment on column ${iol_schema}.mpcs_a92orderconfirm.succamount is '成功金额';
comment on column ${iol_schema}.mpcs_a92orderconfirm.succshare is '成功份额';
comment on column ${iol_schema}.mpcs_a92orderconfirm.succinamount is '转入成功金额';
comment on column ${iol_schema}.mpcs_a92orderconfirm.succinshare is '转入成功份额';
comment on column ${iol_schema}.mpcs_a92orderconfirm.totfee is '总手续费';
comment on column ${iol_schema}.mpcs_a92orderconfirm.taconfirmid is 'ta确认流水号';
comment on column ${iol_schema}.mpcs_a92orderconfirm.pocode is '组合代码';
comment on column ${iol_schema}.mpcs_a92orderconfirm.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a92orderconfirm.accountdate is '资金到账日期';
comment on column ${iol_schema}.mpcs_a92orderconfirm.tradenav is '成交净值';
comment on column ${iol_schema}.mpcs_a92orderconfirm.destnav is '目标基金成交净值';
comment on column ${iol_schema}.mpcs_a92orderconfirm.status is '状态';
comment on column ${iol_schema}.mpcs_a92orderconfirm.reserve1 is '备用字段1';
comment on column ${iol_schema}.mpcs_a92orderconfirm.reserve2 is '备用字段2';
comment on column ${iol_schema}.mpcs_a92orderconfirm.reserve3 is '备用字段3';
comment on column ${iol_schema}.mpcs_a92orderconfirm.reserve4 is '备用字段4';
comment on column ${iol_schema}.mpcs_a92orderconfirm.reserve5 is '备用字段5';
comment on column ${iol_schema}.mpcs_a92orderconfirm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a92orderconfirm.etl_timestamp is 'ETL处理时间戳';
