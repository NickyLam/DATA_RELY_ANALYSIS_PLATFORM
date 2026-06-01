/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_sfggmxdgjk_data_civil
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,count_count_total varchar2(4000) -- 案件总数
    ,count_count_wei_beigao varchar2(4000) -- 被告未结案总数
    ,count_count_beigao varchar2(4000) -- 被告总数
    ,count_count_yuangao varchar2(4000) -- 原告总数
    ,count_money_beigao varchar2(4000) -- 被告金额
    ,count_money_jie_yuangao varchar2(4000) -- 原告已结金额
    ,count_area_stat varchar2(4000) -- 涉案时间分布
    ,count_ay_stat varchar2(4000) -- 涉案案由分布
    ,count_money_wei_yuangao varchar2(4000) -- 原告未结案金额
    ,count_jafs_stat varchar2(4000) -- 结案方式分布
    ,count_count_other varchar2(4000) -- 第三人总数
    ,count_money_yuangao varchar2(4000) -- 原告金额
    ,count_money_wei_beigao varchar2(4000) -- 被告未结案金额
    ,count_larq_stat varchar2(4000) -- 涉案地点分布
    ,count_count_wei_other varchar2(4000) -- 第三人未结案总数
    ,count_count_wei_yuangao varchar2(4000) -- 原告未结案总数
    ,count_money_jie_total varchar2(4000) -- 已结案金额
    ,count_money_jie_beigao varchar2(4000) -- 被告已结案金额
    ,count_money_total varchar2(4000) -- 涉案总金额
    ,count_count_wei_total varchar2(4000) -- 未结案总数
    ,count_count_jie_beigao varchar2(4000) -- 被告已结案总数
    ,cases varchar2(4000) -- cases
    ,count_money_wei_total varchar2(4000) -- 未结案金额
    ,count_money_other varchar2(4000) -- 第三人金额
    ,count_money_wei_percent varchar2(4000) -- 未结案金额百分比
    ,count_money_jie_other varchar2(4000) -- 第三人已结案金额
    ,count_money_wei_other varchar2(4000) -- 第三人未结案金额
    ,count_count_jie_yuangao varchar2(4000) -- 原告已结案总数
    ,count_count_jie_total varchar2(4000) -- 已结案总数
    ,data_civil varchar2(4000) -- 关联标签
    ,count_count_jie_other varchar2(4000) -- 第三人已结案总数
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
grant select on ${iol_schema}.uxds_f_sfggmxdgjk_data_civil to ${iml_schema};
grant select on ${iol_schema}.uxds_f_sfggmxdgjk_data_civil to ${icl_schema};
grant select on ${iol_schema}.uxds_f_sfggmxdgjk_data_civil to ${idl_schema};
grant select on ${iol_schema}.uxds_f_sfggmxdgjk_data_civil to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_sfggmxdgjk_data_civil is '司法研究院监控接口相关数据';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_total is '案件总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_wei_beigao is '被告未结案总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_beigao is '被告总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_yuangao is '原告总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_beigao is '被告金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_jie_yuangao is '原告已结金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_area_stat is '涉案时间分布';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_ay_stat is '涉案案由分布';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_wei_yuangao is '原告未结案金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_jafs_stat is '结案方式分布';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_other is '第三人总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_yuangao is '原告金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_wei_beigao is '被告未结案金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_larq_stat is '涉案地点分布';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_wei_other is '第三人未结案总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_wei_yuangao is '原告未结案总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_jie_total is '已结案金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_jie_beigao is '被告已结案金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_total is '涉案总金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_wei_total is '未结案总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_jie_beigao is '被告已结案总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.cases is 'cases';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_wei_total is '未结案金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_other is '第三人金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_wei_percent is '未结案金额百分比';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_jie_other is '第三人已结案金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_money_wei_other is '第三人未结案金额';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_jie_yuangao is '原告已结案总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_jie_total is '已结案总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.data_civil is '关联标签';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.count_count_jie_other is '第三人已结案总数';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_sfggmxdgjk_data_civil.etl_timestamp is 'ETL处理时间戳';
