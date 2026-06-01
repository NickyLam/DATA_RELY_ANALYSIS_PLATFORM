/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_accounting_booking
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_accounting_booking
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_accounting_booking purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_accounting_booking(
    serialno varchar2(32) -- 记账记录流水号
    ,clientno varchar2(64) -- 客户编号
    ,clrid varchar2(32) -- 押品编号
    ,registertype varchar2(10) -- 登记簿类型（1-无实物押品、2-风管有实物、3-营运有实物）
    ,collattype varchar2(10) -- 押品记账登记类型（1-抵押、2-质押、3-代保管）
    ,ccy varchar2(3) -- 押品记账价值币种
    ,collatamount number(20,2) -- 押品记账价值金额
    ,paymentdirection varchar2(10) -- 收付方向（1-收、2-付）
    ,branch varchar2(64) -- 记账机构
    ,company varchar2(100) -- 法人
    ,prodtype varchar2(64) -- 产品类型
    ,globalno varchar2(50) -- 交易全局流水号
    ,transeqno varchar2(64) -- 交易流水号
    ,trandate varchar2(8) -- 交易日期
    ,trantimestamp varchar2(20) -- 交易时间戳
    ,transtatus varchar2(10) -- 交易状态（0-待处理，1-已发核算中台，2-记账成功，3-记账失败）
    ,remark varchar2(600) -- 备注
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
grant select on ${iol_schema}.icms_clr_accounting_booking to ${iml_schema};
grant select on ${iol_schema}.icms_clr_accounting_booking to ${icl_schema};
grant select on ${iol_schema}.icms_clr_accounting_booking to ${idl_schema};
grant select on ${iol_schema}.icms_clr_accounting_booking to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_accounting_booking is '押品记账记录表';
comment on column ${iol_schema}.icms_clr_accounting_booking.serialno is '记账记录流水号';
comment on column ${iol_schema}.icms_clr_accounting_booking.clientno is '客户编号';
comment on column ${iol_schema}.icms_clr_accounting_booking.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_accounting_booking.registertype is '登记簿类型（1-无实物押品、2-风管有实物、3-营运有实物）';
comment on column ${iol_schema}.icms_clr_accounting_booking.collattype is '押品记账登记类型（1-抵押、2-质押、3-代保管）';
comment on column ${iol_schema}.icms_clr_accounting_booking.ccy is '押品记账价值币种';
comment on column ${iol_schema}.icms_clr_accounting_booking.collatamount is '押品记账价值金额';
comment on column ${iol_schema}.icms_clr_accounting_booking.paymentdirection is '收付方向（1-收、2-付）';
comment on column ${iol_schema}.icms_clr_accounting_booking.branch is '记账机构';
comment on column ${iol_schema}.icms_clr_accounting_booking.company is '法人';
comment on column ${iol_schema}.icms_clr_accounting_booking.prodtype is '产品类型';
comment on column ${iol_schema}.icms_clr_accounting_booking.globalno is '交易全局流水号';
comment on column ${iol_schema}.icms_clr_accounting_booking.transeqno is '交易流水号';
comment on column ${iol_schema}.icms_clr_accounting_booking.trandate is '交易日期';
comment on column ${iol_schema}.icms_clr_accounting_booking.trantimestamp is '交易时间戳';
comment on column ${iol_schema}.icms_clr_accounting_booking.transtatus is '交易状态（0-待处理，1-已发核算中台，2-记账成功，3-记账失败）';
comment on column ${iol_schema}.icms_clr_accounting_booking.remark is '备注';
comment on column ${iol_schema}.icms_clr_accounting_booking.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_accounting_booking.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_accounting_booking.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_accounting_booking.etl_timestamp is 'ETL处理时间戳';
