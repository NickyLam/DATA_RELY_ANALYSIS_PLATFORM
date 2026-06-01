/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_gs_historyratinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_gs_historyratinfo
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_gs_historyratinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_gs_historyratinfo(
    modelcode varchar2(8) -- 体系类型代号
    ,index1 varchar2(50) -- 对象代码1
    ,index2 varchar2(50) -- 对象代码2
    ,index3 varchar2(50) -- 对象代码3
    ,index4 varchar2(50) -- 对象代码4
    ,index5 varchar2(50) -- 对象代码5
    ,snumberrat varchar2(30) -- 评级流水号
    ,year varchar2(6) -- 评级报表年月
    ,risklevel varchar2(4) -- 确认等级
    ,wavelevel varchar2(2) -- 波动级别
    ,warnstate varchar2(1) -- 预警状态
    ,policy varchar2(1) -- 政策取向
    ,ratdate date -- 评级生效日期
    ,ratdateend date -- 评级到期时间
    ,pd number(10,6) -- 违约概率
    ,loansugg number(16,2) -- 授信限额
    ,operatorid varchar2(20) -- 评级操作员
    ,reporttimes varchar2(20) -- 基准报表
    ,faud varchar2(30) -- 审核序号
    ,gettype varchar2(1) -- 结果产生方式
    ,finalresultlsh varchar2(30) -- 结果对应评级流水号
    ,overthing varchar2(200) -- 推翻原因
    ,finalcompname varchar2(100) -- 最终外部评级公司名称
    ,anewoutratedta varchar2(10) -- 外部评级日期
    ,anewoutrateenddta varchar2(10) -- 外部评级截止日期
    ,reviewflag varchar2(1) -- 是否审核
    ,custtype varchar2(10) -- 客户类型
    ,rattype varchar2(1) -- 评级类型
    ,overturn varchar2(1) -- 是否推翻
    ,modellevel varchar2(4) -- 模型等级
    ,modelscore number -- 模型得分
    ,audittype varchar2(1) -- 意见类型
    ,modellsh number -- 模型编号(暂未维护)
    ,loanlevel varchar2(4) -- 债项等级(暂未维护)
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
grant select on ${iol_schema}.nrrs_gs_historyratinfo to ${iml_schema};
grant select on ${iol_schema}.nrrs_gs_historyratinfo to ${icl_schema};
grant select on ${iol_schema}.nrrs_gs_historyratinfo to ${idl_schema};
grant select on ${iol_schema}.nrrs_gs_historyratinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_gs_historyratinfo is '评级结果历史表';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.modelcode is '体系类型代号';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.index1 is '对象代码1';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.index2 is '对象代码2';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.index3 is '对象代码3';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.index4 is '对象代码4';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.index5 is '对象代码5';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.snumberrat is '评级流水号';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.year is '评级报表年月';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.risklevel is '确认等级';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.wavelevel is '波动级别';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.warnstate is '预警状态';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.policy is '政策取向';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.ratdate is '评级生效日期';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.ratdateend is '评级到期时间';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.pd is '违约概率';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.loansugg is '授信限额';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.operatorid is '评级操作员';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.reporttimes is '基准报表';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.faud is '审核序号';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.gettype is '结果产生方式';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.finalresultlsh is '结果对应评级流水号';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.overthing is '推翻原因';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.finalcompname is '最终外部评级公司名称';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.anewoutratedta is '外部评级日期';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.anewoutrateenddta is '外部评级截止日期';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.reviewflag is '是否审核';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.custtype is '客户类型';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.rattype is '评级类型';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.overturn is '是否推翻';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.modellevel is '模型等级';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.modelscore is '模型得分';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.audittype is '意见类型';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.modellsh is '模型编号(暂未维护)';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.loanlevel is '债项等级(暂未维护)';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_gs_historyratinfo.etl_timestamp is 'ETL处理时间戳';
