/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a68tquerymsg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a68tquerymsg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a68tquerymsg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a68tquerymsg(
    mainseq varchar2(24) -- 行内中台流水号
    ,transdt varchar2(12) -- 交易日期
    ,cnsdt varchar2(12) -- 委托日期  委托日期（登记人行日期）
    ,txid varchar2(12) -- 退回申请号  报文标识号
    ,txtpcd varchar2(8) -- 业务类型
    ,instgpty varchar2(21) -- 发起参与机构  发起直接参与机构号
    ,instdpty varchar2(21) -- 接收参与机构  接收直接参与机构号
    ,sndbrn varchar2(21) -- 发起行行号
    ,iotype varchar2(2) -- 往来标志
    ,qrytp varchar2(2) -- 查询方式  0:单笔查询 1: 批量单笔查询
    ,status varchar2(3) -- 处理状态
    ,payacct varchar2(53) -- 付款人账号
    ,payname varchar2(180) -- 付款人名称
    ,rcvacct varchar2(53) -- 收款人账号
    ,rcvname varchar2(180) -- 收款人名称
    ,orgnlcnsdt varchar2(12) -- 原委托日期
    ,orgnltxtpcd varchar2(21) -- 原业务类型
    ,orgnltxid varchar2(12) -- 原支付交易序号  原报文标识号
    ,orgnlinstgpty varchar2(21) -- 原发起方参与机构  委托机构
    ,orgnltransamt varchar2(26) -- 原交易金额
    ,orgnlcrcycd varchar2(5) -- 原币种
    ,orgnldttxid varchar2(24) -- 原明细标识号
    ,orgnldttransamt varchar2(26) -- 原明细金额
    ,orgnldtcrcycd varchar2(5) -- 原明细币种
    ,sndtlr varchar2(750) -- 发送柜员
    ,magebrn varchar2(9) -- 处理机构
    ,dotime varchar2(12) -- 发送日期  中台日期
    ,reqtime varchar2(21) -- 申请时间
    ,rettime varchar2(21) -- 应答时间
    ,rspcnsdt varchar2(12) -- 应答日期
    ,rsptxid varchar2(12) -- 应答标识号
    ,rspinstgpty varchar2(21) -- 应答委托参与机构
    ,rspinstdpty varchar2(21) -- 应答接收参与机构
    ,sts varchar2(3) -- 中心返回状态
    ,rspncd varchar2(12) -- 中心返回码
    ,rspninf varchar2(315) -- 中心返回信息
    ,rtncd varchar2(12) -- 银行返回码
    ,rtninf varchar2(90) -- 银行返回信息
    ,info varchar2(383) -- 附言
    ,info2 varchar2(383) -- 附言2
    ,sndbrnname varchar2(90) -- 付款行行名
    ,rcvbrnname varchar2(90) -- 收款行行名
    ,sndbrnnm varchar2(90) -- 发起行行名
    ,dbtrid varchar2(21) -- 付款行行行号
    ,cdtrid varchar2(21) -- 收款行行行号
    ,rsptxtpcd varchar2(5) -- 应答业务类型
    ,rspsndbrn varchar2(21) -- 应答发起行
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
grant select on ${iol_schema}.mpcs_a68tquerymsg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a68tquerymsg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a68tquerymsg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a68tquerymsg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a68tquerymsg is '深同城查询书登记簿';
comment on column ${iol_schema}.mpcs_a68tquerymsg.mainseq is '行内中台流水号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a68tquerymsg.cnsdt is '委托日期  委托日期（登记人行日期）';
comment on column ${iol_schema}.mpcs_a68tquerymsg.txid is '退回申请号  报文标识号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.txtpcd is '业务类型';
comment on column ${iol_schema}.mpcs_a68tquerymsg.instgpty is '发起参与机构  发起直接参与机构号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.instdpty is '接收参与机构  接收直接参与机构号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.sndbrn is '发起行行号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.iotype is '往来标志';
comment on column ${iol_schema}.mpcs_a68tquerymsg.qrytp is '查询方式  0:单笔查询 1: 批量单笔查询';
comment on column ${iol_schema}.mpcs_a68tquerymsg.status is '处理状态';
comment on column ${iol_schema}.mpcs_a68tquerymsg.payacct is '付款人账号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.payname is '付款人名称';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rcvacct is '收款人账号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rcvname is '收款人名称';
comment on column ${iol_schema}.mpcs_a68tquerymsg.orgnlcnsdt is '原委托日期';
comment on column ${iol_schema}.mpcs_a68tquerymsg.orgnltxtpcd is '原业务类型';
comment on column ${iol_schema}.mpcs_a68tquerymsg.orgnltxid is '原支付交易序号  原报文标识号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.orgnlinstgpty is '原发起方参与机构  委托机构';
comment on column ${iol_schema}.mpcs_a68tquerymsg.orgnltransamt is '原交易金额';
comment on column ${iol_schema}.mpcs_a68tquerymsg.orgnlcrcycd is '原币种';
comment on column ${iol_schema}.mpcs_a68tquerymsg.orgnldttxid is '原明细标识号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.orgnldttransamt is '原明细金额';
comment on column ${iol_schema}.mpcs_a68tquerymsg.orgnldtcrcycd is '原明细币种';
comment on column ${iol_schema}.mpcs_a68tquerymsg.sndtlr is '发送柜员';
comment on column ${iol_schema}.mpcs_a68tquerymsg.magebrn is '处理机构';
comment on column ${iol_schema}.mpcs_a68tquerymsg.dotime is '发送日期  中台日期';
comment on column ${iol_schema}.mpcs_a68tquerymsg.reqtime is '申请时间';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rettime is '应答时间';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rspcnsdt is '应答日期';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rsptxid is '应答标识号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rspinstgpty is '应答委托参与机构';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rspinstdpty is '应答接收参与机构';
comment on column ${iol_schema}.mpcs_a68tquerymsg.sts is '中心返回状态';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rspncd is '中心返回码';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rspninf is '中心返回信息';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rtncd is '银行返回码';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rtninf is '银行返回信息';
comment on column ${iol_schema}.mpcs_a68tquerymsg.info is '附言';
comment on column ${iol_schema}.mpcs_a68tquerymsg.info2 is '附言2';
comment on column ${iol_schema}.mpcs_a68tquerymsg.sndbrnname is '付款行行名';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rcvbrnname is '收款行行名';
comment on column ${iol_schema}.mpcs_a68tquerymsg.sndbrnnm is '发起行行名';
comment on column ${iol_schema}.mpcs_a68tquerymsg.dbtrid is '付款行行行号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.cdtrid is '收款行行行号';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rsptxtpcd is '应答业务类型';
comment on column ${iol_schema}.mpcs_a68tquerymsg.rspsndbrn is '应答发起行';
comment on column ${iol_schema}.mpcs_a68tquerymsg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a68tquerymsg.etl_timestamp is 'ETL处理时间戳';
