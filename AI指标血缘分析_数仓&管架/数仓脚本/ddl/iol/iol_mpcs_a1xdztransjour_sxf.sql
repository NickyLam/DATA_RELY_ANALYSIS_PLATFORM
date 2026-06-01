/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1xdztransjour_sxf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1xdztransjour_sxf
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1xdztransjour_sxf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1xdztransjour_sxf(
    transdate varchar2(12) -- 清算日期
    ,keyid varchar2(96) -- 流水唯一KEY
    ,accptrid varchar2(23) -- 商户编号
    ,orderid varchar2(48) -- 商户交易流水号
    ,payno varchar2(48) -- 平台交易流水号
    ,transtime varchar2(30) -- 交易时间
    ,productno varchar2(6) -- 产品 ONFC-线上外卡
    ,paycategory varchar2(45) -- 交易类型 SALE：消费 REFUND：退款
    ,paychannel varchar2(45) -- 支付渠道 international_card：国际卡
    ,paytype varchar2(30) -- 支付方式 card_entry：银行卡
    ,currency varchar2(5) -- 订单币种
    ,amount varchar2(23) -- 订单金额
    ,paycurrency varchar2(5) -- 本地币种
    ,payamount varchar2(23) -- 本地金额
    ,payfee varchar2(23) -- 本地商户手续费(收)
    ,payfeerate varchar2(24) -- 交易手续费率(%)
    ,discountamount varchar2(23) -- 优惠金额
    ,refundamount varchar2(23) -- 已退款金额
    ,refundfee varchar2(23) -- 本地已退款商户手续费(返)
    ,szltflag varchar2(3) -- 是否收支两条线标识 00：是 01：否
    ,szltrecfeeamt varchar2(23) -- 后收手续费
    ,cappingfee varchar2(24) -- 银联二维码1000以上借记卡手续费封顶值
    ,oriorderid varchar2(48) -- 原商户交易流水号
    ,oripayno varchar2(48) -- 原平台交易流水号
    ,priacct varchar2(45) -- 卡号(脱敏)
    ,drtype varchar2(3) -- 借贷标识 1：借记卡 2：贷记卡 3：其他
    ,oversea varchar2(3) -- 境内外标识
    ,cardorg varchar2(3) -- 卡组织 01：VISA卡 02：万事达卡 03：美运卡
    ,sncode varchar2(75) -- 设备SN
    ,storeno varchar2(45) -- 平台门店编号
    ,auth3ds varchar2(3) -- 是否3DS 01：是 00：否
    ,status varchar2(2) -- 对账标识 0-未对过账 1-已对过账 N-正常交易 C-交易被撤销 R-交易被冲正
    ,remakr1 varchar2(384) -- 备用1
    ,remakr2 varchar2(384) -- 备用2
    ,remakr3 varchar2(768) -- 备用3
    ,remakr4 varchar2(768) -- 备用4
    ,remakr5 varchar2(1536) -- 备用5
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
grant select on ${iol_schema}.mpcs_a1xdztransjour_sxf to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1xdztransjour_sxf to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1xdztransjour_sxf to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1xdztransjour_sxf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1xdztransjour_sxf is '旅行通卡随行付对账流水表';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.transdate is '清算日期';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.keyid is '流水唯一KEY';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.accptrid is '商户编号';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.orderid is '商户交易流水号';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.payno is '平台交易流水号';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.transtime is '交易时间';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.productno is '产品 ONFC-线上外卡';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.paycategory is '交易类型 SALE：消费 REFUND：退款';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.paychannel is '支付渠道 international_card：国际卡';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.paytype is '支付方式 card_entry：银行卡';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.currency is '订单币种';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.amount is '订单金额';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.paycurrency is '本地币种';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.payamount is '本地金额';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.payfee is '本地商户手续费(收)';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.payfeerate is '交易手续费率(%)';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.discountamount is '优惠金额';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.refundamount is '已退款金额';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.refundfee is '本地已退款商户手续费(返)';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.szltflag is '是否收支两条线标识 00：是 01：否';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.szltrecfeeamt is '后收手续费';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.cappingfee is '银联二维码1000以上借记卡手续费封顶值';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.oriorderid is '原商户交易流水号';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.oripayno is '原平台交易流水号';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.priacct is '卡号(脱敏)';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.drtype is '借贷标识 1：借记卡 2：贷记卡 3：其他';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.oversea is '境内外标识';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.cardorg is '卡组织 01：VISA卡 02：万事达卡 03：美运卡';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.sncode is '设备SN';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.storeno is '平台门店编号';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.auth3ds is '是否3DS 01：是 00：否';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.status is '对账标识 0-未对过账 1-已对过账 N-正常交易 C-交易被撤销 R-交易被冲正';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.remakr1 is '备用1';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.remakr2 is '备用2';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.remakr3 is '备用3';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.remakr4 is '备用4';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.remakr5 is '备用5';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1xdztransjour_sxf.etl_timestamp is 'ETL处理时间戳';
