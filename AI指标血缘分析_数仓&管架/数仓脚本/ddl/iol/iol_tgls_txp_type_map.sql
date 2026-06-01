/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_txp_type_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_txp_type_map
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_txp_type_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_txp_type_map(
    stacid number(9) -- 账套
    ,prodcd varchar2(30) -- 类别（产品）
    ,prodp1 varchar2(30) -- 属性1值
    ,prodp2 varchar2(30) -- 属性2
    ,prodp3 varchar2(30) -- 属性3
    ,prodp4 varchar2(30) -- 属性4
    ,prodp5 varchar2(30) -- 属性5
    ,prodp6 varchar2(30) -- 属性6
    ,prodp7 varchar2(30) -- 属性7
    ,prodp8 varchar2(30) -- 属性8
    ,prodp9 varchar2(30) -- 属性9
    ,prodpa varchar2(30) -- 属性10
    ,typecd varchar2(30) -- 税目
    ,taxvtg varchar2(4) -- 进项销项标识：进项(in)、销项(ou)
    ,opracd varchar2(10) -- 分离动作：销项可取值为涉票（tis）、涉税（tax）、摊销或计提调整（tad）进项可取值为涉票（tis）、摊销或计提调整（tad）
    ,toamnt varchar2(2) -- b-蓝字r-红字
    ,toitem varchar2(16) -- 对方科目
    ,adjutg varchar2(1) -- 账务调整标识（0：不调整核算1：调整核算）调整核算时采用红字冲字
    ,itemaj varchar2(16) -- 调整科目（为空则为原科目）
    ,sepatg varchar2(1) -- 分离标识
    ,usedtg varchar2(1) -- 使用标识（0：未使用1：已使用2：停用）
    ,reason varchar2(150) -- 修改原因
    ,modidt date -- 创建时间（格式yyyy-mm-ddhh24:mm:ss）
    ,spuuid number -- 分离规则唯一标识
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
grant select on ${iol_schema}.tgls_txp_type_map to ${iml_schema};
grant select on ${iol_schema}.tgls_txp_type_map to ${icl_schema};
grant select on ${iol_schema}.tgls_txp_type_map to ${idl_schema};
grant select on ${iol_schema}.tgls_txp_type_map to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_txp_type_map is '分离规则配置实现表';
comment on column ${iol_schema}.tgls_txp_type_map.stacid is '账套';
comment on column ${iol_schema}.tgls_txp_type_map.prodcd is '类别（产品）';
comment on column ${iol_schema}.tgls_txp_type_map.prodp1 is '属性1值';
comment on column ${iol_schema}.tgls_txp_type_map.prodp2 is '属性2';
comment on column ${iol_schema}.tgls_txp_type_map.prodp3 is '属性3';
comment on column ${iol_schema}.tgls_txp_type_map.prodp4 is '属性4';
comment on column ${iol_schema}.tgls_txp_type_map.prodp5 is '属性5';
comment on column ${iol_schema}.tgls_txp_type_map.prodp6 is '属性6';
comment on column ${iol_schema}.tgls_txp_type_map.prodp7 is '属性7';
comment on column ${iol_schema}.tgls_txp_type_map.prodp8 is '属性8';
comment on column ${iol_schema}.tgls_txp_type_map.prodp9 is '属性9';
comment on column ${iol_schema}.tgls_txp_type_map.prodpa is '属性10';
comment on column ${iol_schema}.tgls_txp_type_map.typecd is '税目';
comment on column ${iol_schema}.tgls_txp_type_map.taxvtg is '进项销项标识：进项(in)、销项(ou)';
comment on column ${iol_schema}.tgls_txp_type_map.opracd is '分离动作：销项可取值为涉票（tis）、涉税（tax）、摊销或计提调整（tad）进项可取值为涉票（tis）、摊销或计提调整（tad）';
comment on column ${iol_schema}.tgls_txp_type_map.toamnt is 'b-蓝字r-红字';
comment on column ${iol_schema}.tgls_txp_type_map.toitem is '对方科目';
comment on column ${iol_schema}.tgls_txp_type_map.adjutg is '账务调整标识（0：不调整核算1：调整核算）调整核算时采用红字冲字';
comment on column ${iol_schema}.tgls_txp_type_map.itemaj is '调整科目（为空则为原科目）';
comment on column ${iol_schema}.tgls_txp_type_map.sepatg is '分离标识';
comment on column ${iol_schema}.tgls_txp_type_map.usedtg is '使用标识（0：未使用1：已使用2：停用）';
comment on column ${iol_schema}.tgls_txp_type_map.reason is '修改原因';
comment on column ${iol_schema}.tgls_txp_type_map.modidt is '创建时间（格式yyyy-mm-ddhh24:mm:ss）';
comment on column ${iol_schema}.tgls_txp_type_map.spuuid is '分离规则唯一标识';
comment on column ${iol_schema}.tgls_txp_type_map.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_txp_type_map.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_txp_type_map.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_txp_type_map.etl_timestamp is 'ETL处理时间戳';
