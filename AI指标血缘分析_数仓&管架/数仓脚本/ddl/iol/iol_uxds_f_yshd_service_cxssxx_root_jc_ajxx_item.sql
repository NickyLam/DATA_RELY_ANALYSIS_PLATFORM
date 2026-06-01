/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_yshd_service_cxssxx_root_jc_ajxx_item
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,sjskze varchar2(4000) -- 实缴税款总额
    ,jcssqjq varchar2(4000) -- 检查所属期间起
    ,swjctzssdrq varchar2(4000) -- 税务检查通知书送达日期
    ,yjskze varchar2(4000) -- 应缴税款总额
    ,sjznjze varchar2(4000) -- 实缴滞纳金总额
    ,zxdjrq varchar2(4000) -- 执行登记日期
    ,rwxdrq varchar2(4000) -- 任务下达日期
    ,yjfkze varchar2(4000) -- 应缴罚款总额
    ,sjfkze varchar2(4000) -- 实缴罚款总额
    ,sljsrq varchar2(4000) -- 审理结束日期
    ,larq varchar2(4000) -- 立案日期
    ,jcjsrq varchar2(4000) -- 检查结束日期
    ,zxwbrq varchar2(4000) -- 执行完毕日期
    ,shxydm varchar2(4000) -- 社会信用代码
    ,ajmc varchar2(4000) -- 案件名称
    ,lrrq varchar2(4000) -- 录入日期
    ,jcdjrq varchar2(4000) -- 检查登记日期
    ,ajlxmc varchar2(4000) -- 案件类型名称
    ,jcrqq varchar2(4000) -- 检查日期起
    ,sldjrq varchar2(4000) -- 审理登记日期
    ,item varchar2(4000) -- 关联标签
    ,jcssqjz varchar2(4000) -- 检查所属期间止
    ,yjznjze varchar2(4000) -- 应缴滞纳金总额
    ,jcajbh varchar2(4000) -- 稽查案件编号
    ,slyj2 varchar2(4000) -- 审理意见
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
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item to ${iml_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item to ${icl_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item to ${idl_schema};
grant select on ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item is '深圳税局涉税信息稽查案件信息';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.sjskze is '实缴税款总额';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.jcssqjq is '检查所属期间起';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.swjctzssdrq is '税务检查通知书送达日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.yjskze is '应缴税款总额';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.sjznjze is '实缴滞纳金总额';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.zxdjrq is '执行登记日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.rwxdrq is '任务下达日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.yjfkze is '应缴罚款总额';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.sjfkze is '实缴罚款总额';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.sljsrq is '审理结束日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.larq is '立案日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.jcjsrq is '检查结束日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.zxwbrq is '执行完毕日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.shxydm is '社会信用代码';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.ajmc is '案件名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.lrrq is '录入日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.jcdjrq is '检查登记日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.ajlxmc is '案件类型名称';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.jcrqq is '检查日期起';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.sldjrq is '审理登记日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.item is '关联标签';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.jcssqjz is '检查所属期间止';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.yjznjze is '应缴滞纳金总额';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.jcajbh is '稽查案件编号';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.slyj2 is '审理意见';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_yshd_service_cxssxx_root_jc_ajxx_item.etl_timestamp is 'ETL处理时间戳';
