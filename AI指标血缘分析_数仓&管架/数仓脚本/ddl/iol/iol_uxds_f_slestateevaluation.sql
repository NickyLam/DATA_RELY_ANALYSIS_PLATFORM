/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_slestateevaluation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_slestateevaluation
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_slestateevaluation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_slestateevaluation(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,caseid varchar2(4000) -- 案例编号
    ,divisionid varchar2(4000) -- 行政区划编码
    ,address varchar2(4000) -- 物业地址
    ,unitprice varchar2(4000) -- 评估单价
    ,totalprice varchar2(4000) -- 评估总价
    ,priceringrate varchar2(4000) -- 环比
    ,priceyearrate varchar2(4000) -- 同比
    ,querydate varchar2(4000) -- 询价时间
    ,avgunitprice varchar2(4000) -- 案例均价
    ,avgprice varchar2(4000) -- 楼盘均价
    ,maxprice varchar2(4000) -- 最大值
    ,minprice varchar2(4000) -- 最小值
    ,mangerprice varchar2(4000) -- 物业费
    ,liveness varchar2(4000) -- 活跃度
    ,totalcellnumber varchar2(4000) -- 总套数
    ,querycount varchar2(4000) -- 近3个月被查询次数（不含机构
    ,returncode varchar2(4000) -- 估价状态
    ,remark varchar2(4000) -- 返回信息
    ,enddate varchar2(4000) -- 建成年代
    ,constructionname varchar2(4000) -- 楼盘名称
    ,constructionalias varchar2(4000) -- 楼盘别名
    ,buildingname varchar2(4000) -- 楼栋名称
    ,housename varchar2(4000) -- 房号名称
    ,propertytype varchar2(4000) -- 房屋用途
    ,quotationcount varchar2(4000) -- 案例数量
    ,genmonth varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_slestateevaluation to ${iml_schema};
grant select on ${iol_schema}.uxds_f_slestateevaluation to ${icl_schema};
grant select on ${iol_schema}.uxds_f_slestateevaluation to ${idl_schema};
grant select on ${iol_schema}.uxds_f_slestateevaluation to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_slestateevaluation is 'slEstateEvaluation';
comment on column ${iol_schema}.uxds_f_slestateevaluation.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_slestateevaluation.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_slestateevaluation.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_slestateevaluation.caseid is '案例编号';
comment on column ${iol_schema}.uxds_f_slestateevaluation.divisionid is '行政区划编码';
comment on column ${iol_schema}.uxds_f_slestateevaluation.address is '物业地址';
comment on column ${iol_schema}.uxds_f_slestateevaluation.unitprice is '评估单价';
comment on column ${iol_schema}.uxds_f_slestateevaluation.totalprice is '评估总价';
comment on column ${iol_schema}.uxds_f_slestateevaluation.priceringrate is '环比';
comment on column ${iol_schema}.uxds_f_slestateevaluation.priceyearrate is '同比';
comment on column ${iol_schema}.uxds_f_slestateevaluation.querydate is '询价时间';
comment on column ${iol_schema}.uxds_f_slestateevaluation.avgunitprice is '案例均价';
comment on column ${iol_schema}.uxds_f_slestateevaluation.avgprice is '楼盘均价';
comment on column ${iol_schema}.uxds_f_slestateevaluation.maxprice is '最大值';
comment on column ${iol_schema}.uxds_f_slestateevaluation.minprice is '最小值';
comment on column ${iol_schema}.uxds_f_slestateevaluation.mangerprice is '物业费';
comment on column ${iol_schema}.uxds_f_slestateevaluation.liveness is '活跃度';
comment on column ${iol_schema}.uxds_f_slestateevaluation.totalcellnumber is '总套数';
comment on column ${iol_schema}.uxds_f_slestateevaluation.querycount is '近3个月被查询次数（不含机构';
comment on column ${iol_schema}.uxds_f_slestateevaluation.returncode is '估价状态';
comment on column ${iol_schema}.uxds_f_slestateevaluation.remark is '返回信息';
comment on column ${iol_schema}.uxds_f_slestateevaluation.enddate is '建成年代';
comment on column ${iol_schema}.uxds_f_slestateevaluation.constructionname is '楼盘名称';
comment on column ${iol_schema}.uxds_f_slestateevaluation.constructionalias is '楼盘别名';
comment on column ${iol_schema}.uxds_f_slestateevaluation.buildingname is '楼栋名称';
comment on column ${iol_schema}.uxds_f_slestateevaluation.housename is '房号名称';
comment on column ${iol_schema}.uxds_f_slestateevaluation.propertytype is '房屋用途';
comment on column ${iol_schema}.uxds_f_slestateevaluation.quotationcount is '案例数量';
comment on column ${iol_schema}.uxds_f_slestateevaluation.genmonth is '';
comment on column ${iol_schema}.uxds_f_slestateevaluation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_slestateevaluation.etl_timestamp is 'ETL处理时间戳';
