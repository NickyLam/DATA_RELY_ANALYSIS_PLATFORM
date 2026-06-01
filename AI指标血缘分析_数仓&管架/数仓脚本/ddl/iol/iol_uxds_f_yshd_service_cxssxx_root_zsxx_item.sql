/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_yshd_service_cxssxx_root_zsxx_item
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,nssbrq varchar2(4000) -- 纳税申报日期
    ,sbsxmc_1 varchar2(4000) -- 申报属性名称
    ,zspmmc varchar2(4000) -- 征收品目名称
    ,cbsxmc varchar2(4000) -- 查补属性名称
    ,tzlxmc varchar2(4000) -- 调账类型名称
    ,yjkqx varchar2(4000) -- 原缴款期限
    ,jkqx varchar2(4000) -- 缴款期限
    ,yjse varchar2(4000) -- 已缴税额
    ,zsxmmc varchar2(4000) -- 征收项目名称
    ,zsdlfsmc varchar2(4000) -- 征收代理方式名称
    ,zszmmc varchar2(4000) -- 征收子目名称
    ,skzlmc varchar2(4000) -- 税款种类名称
    ,ynse varchar2(4000) -- 应纳税额
    ,sbfsmc varchar2(4000) -- 申报方式名称
    ,yzfsrq varchar2(4000) -- 应征发生日期
    ,zsfsmc varchar2(4000) -- 征收方式名称
    ,shxydm varchar2(4000) -- 社会信用代码
    ,kjjzrq varchar2(4000) -- 会计记账日期
    ,kssl varchar2(4000) -- 课税数量
    ,ssqq varchar2(4000) -- 所属时间起
    ,yzpzzlmc varchar2(4000) -- 应征凭证种类名称
    ,sl_1 varchar2(4000) -- 税率
    ,ssqz varchar2(4000) -- 所属时间止
    ,item varchar2(4000) -- 关联标签
    ,czlxmc varchar2(4000) -- 操作类型名称
    ,jmse varchar2(4000) -- 减免税额
    ,ybtse varchar2(4000) -- 应补
    ,jsyj varchar2(4000) -- 计税依据
    ,sksxmc varchar2(4000) -- 税款属性名称
    ,yzgsrq varchar2(4000) -- 应征归属日期
    ,yzclrq varchar2(4000) -- 应征处理日期
    ,yjskztmc varchar2(4000) -- 税款状态名称
    ,skcllxmc varchar2(4000) -- 税款处理类型名称
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
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item to ${iml_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item to ${icl_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item to ${idl_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item is '深圳税局涉税信息征收信息';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.nssbrq is '纳税申报日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.sbsxmc_1 is '申报属性名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.zspmmc is '征收品目名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.cbsxmc is '查补属性名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.tzlxmc is '调账类型名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.yjkqx is '原缴款期限';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.jkqx is '缴款期限';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.yjse is '已缴税额';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.zsxmmc is '征收项目名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.zsdlfsmc is '征收代理方式名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.zszmmc is '征收子目名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.skzlmc is '税款种类名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.ynse is '应纳税额';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.sbfsmc is '申报方式名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.yzfsrq is '应征发生日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.zsfsmc is '征收方式名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.shxydm is '社会信用代码';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.kjjzrq is '会计记账日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.kssl is '课税数量';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.ssqq is '所属时间起';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.yzpzzlmc is '应征凭证种类名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.sl_1 is '税率';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.ssqz is '所属时间止';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.item is '关联标签';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.czlxmc is '操作类型名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.jmse is '减免税额';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.ybtse is '应补';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.jsyj is '计税依据';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.sksxmc is '税款属性名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.yzgsrq is '应征归属日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.yzclrq is '应征处理日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.yjskztmc is '税款状态名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.skcllxmc is '税款处理类型名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_zsxx_item.etl_timestamp is 'ETL处理时间戳';
