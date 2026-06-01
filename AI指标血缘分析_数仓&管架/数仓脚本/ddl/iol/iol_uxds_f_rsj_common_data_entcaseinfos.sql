/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_rsj_common_data_entcaseinfos
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,creditcode varchar2(4000) -- 统一社会信用代码
    ,illegacttype varchar2(4000) -- 主要违法事实
    ,pendecno varchar2(4000) -- 处罚决定文书
    ,unitname varchar2(4000) -- 当事人名称
    ,pencontent varchar2(4000) -- 行政处罚内容
    ,pentypecn varchar2(4000) -- 处罚种类名称
    ,pentype varchar2(4000) -- 处罚种类名称
    ,publicdate varchar2(4000) -- 公示日期
    ,penauthcn varchar2(4000) -- 处罚机关名称
    ,penauth varchar2(4000) -- 处罚机关名称
    ,data_entcaseinfos varchar2(4000) -- 关联标签
    ,pendecissdate varchar2(4000) -- 处罚决定书签发日期
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
grant select on ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos to ${iml_schema};
grant select on ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos to ${icl_schema};
grant select on ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos to ${idl_schema};
grant select on ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos is '融数据_行政处罚信息';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.creditcode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.illegacttype is '主要违法事实';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.pendecno is '处罚决定文书';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.unitname is '当事人名称';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.pencontent is '行政处罚内容';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.pentypecn is '处罚种类名称';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.pentype is '处罚种类名称';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.publicdate is '公示日期';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.penauthcn is '处罚机关名称';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.penauth is '处罚机关名称';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.data_entcaseinfos is '关联标签';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.pendecissdate is '处罚决定书签发日期';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_rsj_common_data_entcaseinfos.etl_timestamp is 'ETL处理时间戳';
