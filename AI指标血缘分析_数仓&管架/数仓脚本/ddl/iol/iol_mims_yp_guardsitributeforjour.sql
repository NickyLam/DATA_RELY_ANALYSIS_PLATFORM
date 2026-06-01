/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_guardsitributeforjour
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_guardsitributeforjour
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_guardsitributeforjour purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_guardsitributeforjour(
    sccode varchar2(48) -- 押品编号
    ,contractno varchar2(75) -- 合同号
    ,balance number(20,2) -- 合同余额
    ,distvalue number(20,2) -- 贷款分配价值
    ,contguartype varchar2(3) -- 合同主担保方式
    ,guartype varchar2(30) -- 押品类型
    ,credittype varchar2(45) -- 业务品种
    ,barsign varchar2(2) -- 条线
    ,interindustry varchar2(15) -- 行业
    ,custscale varchar2(15) -- 规模
    ,reporttype varchar2(2) -- 表内表外标识
    ,deptcode varchar2(45) -- 所属机构
    ,fiveclass varchar2(9) -- 五级分类
    ,credno varchar2(60) -- 借据号
    ,bal number(16,2) -- 借据余额
    ,confmamt number(20,2) -- 分配我行确认价值
    ,firstconfmamt number(20,2) -- 分配初评我行确认价值
    ,datecode varchar2(9) -- 报表日期
    ,credlevel varchar2(15) -- 分配等级 1:一级分配 2:二级分配
    ,creditname varchar2(750) -- 业务品种名称
    ,occurtype varchar2(6) -- 发生类型
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
grant select on ${iol_schema}.mims_yp_guardsitributeforjour to ${iml_schema};
grant select on ${iol_schema}.mims_yp_guardsitributeforjour to ${icl_schema};
grant select on ${iol_schema}.mims_yp_guardsitributeforjour to ${idl_schema};
grant select on ${iol_schema}.mims_yp_guardsitributeforjour to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_guardsitributeforjour is '按业务规则分配G13结果表';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.sccode is '押品编号';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.contractno is '合同号';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.balance is '合同余额';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.distvalue is '贷款分配价值';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.contguartype is '合同主担保方式';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.guartype is '押品类型';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.credittype is '业务品种';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.barsign is '条线';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.interindustry is '行业';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.custscale is '规模';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.reporttype is '表内表外标识';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.deptcode is '所属机构';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.fiveclass is '五级分类';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.credno is '借据号';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.bal is '借据余额';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.confmamt is '分配我行确认价值';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.firstconfmamt is '分配初评我行确认价值';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.datecode is '报表日期';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.credlevel is '分配等级 1:一级分配 2:二级分配';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.creditname is '业务品种名称';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.occurtype is '发生类型';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.start_dt is '开始时间';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.end_dt is '结束时间';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.id_mark is '增删标志';
comment on column ${iol_schema}.mims_yp_guardsitributeforjour.etl_timestamp is 'ETL处理时间戳';
