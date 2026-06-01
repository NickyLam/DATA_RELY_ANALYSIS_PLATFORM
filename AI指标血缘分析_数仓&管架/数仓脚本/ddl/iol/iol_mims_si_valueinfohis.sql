/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_valueinfohis
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_valueinfohis
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_valueinfohis purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_valueinfohis(
    sccode varchar2(48) -- 押品编号
    ,evalmode varchar2(3) -- 评估方式 01-外部评估      02-内部评估      03-外部和内部评估
    ,evaldate varchar2(15) -- 评估日期 评估价值评估的日期
    ,curreny varchar2(15) -- 币种
    ,rate number(18,10) -- 汇率
    ,outevalexpdate varchar2(15) -- 外部评估价值有效期截止日
    ,outevaldeptcode varchar2(450) -- 外部评估机构
    ,outevalmethod varchar2(150) -- 外部评估方法 01-指数法_外部指数        02-指数法_内部构建指数        03-市场法        04-收益法        05-重置成本法        06-工程进度法        07-非上市公司股权净资产比例法        08-直接引用法_金融质抵质押品        09-直接引用法_动产        10-直接引用法_房地产        11-直接引用法_询价        12-其他
    ,outevalflag varchar2(2) -- 是否有外部预评估报告 0-否            1-是
    ,outevalamt1 number(20,2) -- 外部预评估报告的评估价值
    ,outevaldate varchar2(15) -- 外部正式评估报告评估日期
    ,outevalamt number(20,2) -- 外部正式评估报告的评估价值
    ,evalamt number(20,2) -- 内部评估价值 根据内部评估方法计算出的内部评估价值
    ,evalamt2 number(20,2) -- 申请评估确认价值 分析外部评估和内部评估价值后，客户经理得出评估确认价值
    ,businessinsid varchar2(45) -- 流程编号 我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空
    ,confmamt number(20,2) -- 我行确认价值
    ,condate varchar2(15) -- 评估认定日期
    ,firstoutevalamt number(20,2) -- 初评外部正式评估价值
    ,firstevalamt number(20,2) -- 初评内部评估价值 根据内部评估方法计算出的内部评估价值
    ,firstconfmamt number(20,2) -- 初评我行确认价值
    ,startbusinessinsid varchar2(45) -- 初评流程编号
    ,verecoginition varchar2(2) -- 押品价值认定方式
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
grant select on ${iol_schema}.mims_si_valueinfohis to ${iml_schema};
grant select on ${iol_schema}.mims_si_valueinfohis to ${icl_schema};
grant select on ${iol_schema}.mims_si_valueinfohis to ${idl_schema};
grant select on ${iol_schema}.mims_si_valueinfohis to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_valueinfohis is '押品价值历史信息';
comment on column ${iol_schema}.mims_si_valueinfohis.sccode is '押品编号';
comment on column ${iol_schema}.mims_si_valueinfohis.evalmode is '评估方式 01-外部评估      02-内部评估      03-外部和内部评估';
comment on column ${iol_schema}.mims_si_valueinfohis.evaldate is '评估日期 评估价值评估的日期';
comment on column ${iol_schema}.mims_si_valueinfohis.curreny is '币种';
comment on column ${iol_schema}.mims_si_valueinfohis.rate is '汇率';
comment on column ${iol_schema}.mims_si_valueinfohis.outevalexpdate is '外部评估价值有效期截止日';
comment on column ${iol_schema}.mims_si_valueinfohis.outevaldeptcode is '外部评估机构';
comment on column ${iol_schema}.mims_si_valueinfohis.outevalmethod is '外部评估方法 01-指数法_外部指数        02-指数法_内部构建指数        03-市场法        04-收益法        05-重置成本法        06-工程进度法        07-非上市公司股权净资产比例法        08-直接引用法_金融质抵质押品        09-直接引用法_动产        10-直接引用法_房地产        11-直接引用法_询价        12-其他';
comment on column ${iol_schema}.mims_si_valueinfohis.outevalflag is '是否有外部预评估报告 0-否            1-是';
comment on column ${iol_schema}.mims_si_valueinfohis.outevalamt1 is '外部预评估报告的评估价值';
comment on column ${iol_schema}.mims_si_valueinfohis.outevaldate is '外部正式评估报告评估日期';
comment on column ${iol_schema}.mims_si_valueinfohis.outevalamt is '外部正式评估报告的评估价值';
comment on column ${iol_schema}.mims_si_valueinfohis.evalamt is '内部评估价值 根据内部评估方法计算出的内部评估价值';
comment on column ${iol_schema}.mims_si_valueinfohis.evalamt2 is '申请评估确认价值 分析外部评估和内部评估价值后，客户经理得出评估确认价值';
comment on column ${iol_schema}.mims_si_valueinfohis.businessinsid is '流程编号 我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空';
comment on column ${iol_schema}.mims_si_valueinfohis.confmamt is '我行确认价值';
comment on column ${iol_schema}.mims_si_valueinfohis.condate is '评估认定日期';
comment on column ${iol_schema}.mims_si_valueinfohis.firstoutevalamt is '初评外部正式评估价值';
comment on column ${iol_schema}.mims_si_valueinfohis.firstevalamt is '初评内部评估价值 根据内部评估方法计算出的内部评估价值';
comment on column ${iol_schema}.mims_si_valueinfohis.firstconfmamt is '初评我行确认价值';
comment on column ${iol_schema}.mims_si_valueinfohis.startbusinessinsid is '初评流程编号';
comment on column ${iol_schema}.mims_si_valueinfohis.verecoginition is '押品价值认定方式';
comment on column ${iol_schema}.mims_si_valueinfohis.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_valueinfohis.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_valueinfohis.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_valueinfohis.etl_timestamp is 'ETL处理时间戳';
