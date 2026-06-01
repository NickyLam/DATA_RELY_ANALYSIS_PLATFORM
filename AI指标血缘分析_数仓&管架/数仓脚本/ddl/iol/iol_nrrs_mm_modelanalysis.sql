/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_mm_modelanalysis
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_mm_modelanalysis
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_mm_modelanalysis purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_mm_modelanalysis(
    snumberrat varchar2(30) -- 评级流水号
    ,ratitem varchar2(10) -- 评级期次
    ,indextime varchar2(20) -- 引用指标值期次
    ,index1 varchar2(50) -- 对象代码1
    ,index2 varchar2(50) -- 对象代码2
    ,index3 varchar2(50) -- 对象代码3
    ,index4 varchar2(50) -- 对象代码4
    ,index5 varchar2(50) -- 对象代码5
    ,lsh number -- 模型标识
    ,modelcode varchar2(8) -- 模型代码
    ,indexcode varchar2(20) -- 指标代码
    ,indextype varchar2(1) -- 指标类型
    ,weight number -- 权重
    ,lowlimit number -- 指标下限
    ,uplimit number -- 指标上限
    ,ylowlimit number -- 指标值静态黄色预警分值下限
    ,yuplimit number -- 指标值静态黄色预警分值上限
    ,yinterval varchar2(2) -- 指标值静态黄色预警区间开闭
    ,rlowlimit number -- 指标值静态红色预警分值下限
    ,ruplimit number -- 指标值静态红色预警分值上限
    ,rinterval varchar2(2) -- 指标值静态红色预警区间开闭
    ,ylowlimit2 number -- 分值静态黄色预警分值下限
    ,yuplimit2 number -- 分值静态黄色预警分值上限
    ,yinterval2 varchar2(2) -- 分值静态黄色预警区间开闭
    ,rlowlimit2 number -- 分值静态红色预警分值下限
    ,ruplimit2 number -- 分值静态红色预警分值上限
    ,rinterval2 varchar2(2) -- 分值静态红色预警区间开闭
    ,ylowlimit3 number -- 分值动态黄色预警分值下限
    ,yuplimit3 number -- 分值动态黄色预警分值上限
    ,yinterval3 varchar2(2) -- 分值动态黄色预警区间开闭
    ,rlowlimit3 number -- 分值动态红色预警分值下限
    ,ruplimit3 number -- 分值动态红色预警分值上限
    ,rinterval3 varchar2(2) -- 分值动态红色预警区间开闭
    ,indexvalue varchar2(30) -- 指标值
    ,individvalue number -- 单项分值
    ,indexriskvalue number -- 指标分值
    ,coefficient number -- 风险系数
    ,jqindividvalue number -- 基期单项分值
    ,jqriskvalue number -- 基期指标分值
    ,riskvaluewave number -- 指标分值波动
    ,risklevelinit varchar2(4) -- 初始风险等级
    ,risklevel varchar2(4) -- 风险等级
    ,wavelevel varchar2(2) -- 波动级别
    ,mulwarnflag varchar2(1) -- 综合预警结果
    ,indexwarnflag varchar2(1) -- 指标值预警结果
    ,valueswarnflag varchar2(1) -- 分值静态预警结果
    ,valuedwarnflag varchar2(1) -- 分值波动预警结果
    ,indexlevel varchar2(10) -- 指标等级
    ,oldindexriskvalue number -- 原指标分值
    ,oldindexlevel varchar2(10) -- 原指标等级
    ,reason varchar2(1000) -- 调整原因
    ,indexname varchar2(500) -- 指标名称
    ,upindexcode varchar2(10) -- 指标分组
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
grant select on ${iol_schema}.nrrs_mm_modelanalysis to ${iml_schema};
grant select on ${iol_schema}.nrrs_mm_modelanalysis to ${icl_schema};
grant select on ${iol_schema}.nrrs_mm_modelanalysis to ${idl_schema};
grant select on ${iol_schema}.nrrs_mm_modelanalysis to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_mm_modelanalysis is '评级指标得分信息表';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.snumberrat is '评级流水号';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.ratitem is '评级期次';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.indextime is '引用指标值期次';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.index1 is '对象代码1';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.index2 is '对象代码2';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.index3 is '对象代码3';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.index4 is '对象代码4';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.index5 is '对象代码5';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.lsh is '模型标识';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.modelcode is '模型代码';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.indexcode is '指标代码';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.indextype is '指标类型';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.weight is '权重';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.lowlimit is '指标下限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.uplimit is '指标上限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.ylowlimit is '指标值静态黄色预警分值下限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.yuplimit is '指标值静态黄色预警分值上限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.yinterval is '指标值静态黄色预警区间开闭';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.rlowlimit is '指标值静态红色预警分值下限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.ruplimit is '指标值静态红色预警分值上限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.rinterval is '指标值静态红色预警区间开闭';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.ylowlimit2 is '分值静态黄色预警分值下限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.yuplimit2 is '分值静态黄色预警分值上限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.yinterval2 is '分值静态黄色预警区间开闭';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.rlowlimit2 is '分值静态红色预警分值下限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.ruplimit2 is '分值静态红色预警分值上限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.rinterval2 is '分值静态红色预警区间开闭';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.ylowlimit3 is '分值动态黄色预警分值下限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.yuplimit3 is '分值动态黄色预警分值上限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.yinterval3 is '分值动态黄色预警区间开闭';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.rlowlimit3 is '分值动态红色预警分值下限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.ruplimit3 is '分值动态红色预警分值上限';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.rinterval3 is '分值动态红色预警区间开闭';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.indexvalue is '指标值';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.individvalue is '单项分值';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.indexriskvalue is '指标分值';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.coefficient is '风险系数';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.jqindividvalue is '基期单项分值';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.jqriskvalue is '基期指标分值';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.riskvaluewave is '指标分值波动';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.risklevelinit is '初始风险等级';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.risklevel is '风险等级';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.wavelevel is '波动级别';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.mulwarnflag is '综合预警结果';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.indexwarnflag is '指标值预警结果';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.valueswarnflag is '分值静态预警结果';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.valuedwarnflag is '分值波动预警结果';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.indexlevel is '指标等级';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.oldindexriskvalue is '原指标分值';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.oldindexlevel is '原指标等级';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.reason is '调整原因';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.indexname is '指标名称';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.upindexcode is '指标分组';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nrrs_mm_modelanalysis.etl_timestamp is 'ETL处理时间戳';
