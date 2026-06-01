/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_txtp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_txtp
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_txtp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_txtp(
    typecd varchar2(16) -- 分类代码
    ,typena varchar2(50) -- 名称
    ,vatxrt number(17,8) -- 税率
    ,fromdt varchar2(8) -- 有效起始日
    ,endddt varchar2(8) -- 有效结束日
    ,status varchar2(1) -- 状态
    ,smrytx varchar2(240) -- 备注
    ,dedutg varchar2(1) -- 可抵扣标志（0：否1：是*：无效）——对进项适用
    ,exeptg varchar2(1) -- 应税标识（0：零税率1：是n：免税*：无效）——对销项适用
    ,catxtp varchar2(1) -- 计税方式（s：简易计税n：一般计税）
    ,maketp varchar2(2) -- 开票类型(专票-sp、普票-cm、不能开票-no、无效-nv)
    ,vatxtp varchar2(2) -- 进销项类型(销项-ou、进项-in)
    ,gdsvcd varchar2(20) -- 税收分类编码
    ,dutycd varchar2(240) -- 免税代码
    ,productsena varchar2(240) -- 商品服务名称
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
grant select on ${iol_schema}.tgls_com_txtp to ${iml_schema};
grant select on ${iol_schema}.tgls_com_txtp to ${icl_schema};
grant select on ${iol_schema}.tgls_com_txtp to ${idl_schema};
grant select on ${iol_schema}.tgls_com_txtp to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_txtp is '税目信息';
comment on column ${iol_schema}.tgls_com_txtp.typecd is '分类代码';
comment on column ${iol_schema}.tgls_com_txtp.typena is '名称';
comment on column ${iol_schema}.tgls_com_txtp.vatxrt is '税率';
comment on column ${iol_schema}.tgls_com_txtp.fromdt is '有效起始日';
comment on column ${iol_schema}.tgls_com_txtp.endddt is '有效结束日';
comment on column ${iol_schema}.tgls_com_txtp.status is '状态';
comment on column ${iol_schema}.tgls_com_txtp.smrytx is '备注';
comment on column ${iol_schema}.tgls_com_txtp.dedutg is '可抵扣标志（0：否1：是*：无效）——对进项适用';
comment on column ${iol_schema}.tgls_com_txtp.exeptg is '应税标识（0：零税率1：是n：免税*：无效）——对销项适用';
comment on column ${iol_schema}.tgls_com_txtp.catxtp is '计税方式（s：简易计税n：一般计税）';
comment on column ${iol_schema}.tgls_com_txtp.maketp is '开票类型(专票-sp、普票-cm、不能开票-no、无效-nv)';
comment on column ${iol_schema}.tgls_com_txtp.vatxtp is '进销项类型(销项-ou、进项-in)';
comment on column ${iol_schema}.tgls_com_txtp.gdsvcd is '税收分类编码';
comment on column ${iol_schema}.tgls_com_txtp.dutycd is '免税代码';
comment on column ${iol_schema}.tgls_com_txtp.productsena is '商品服务名称';
comment on column ${iol_schema}.tgls_com_txtp.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_txtp.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_txtp.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_txtp.etl_timestamp is 'ETL处理时间戳';
