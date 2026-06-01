/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_guardistributeforjour
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_guardistributeforjour
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_guardistributeforjour purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_guardistributeforjour(
    datecode varchar2(6) -- 报表日期
    ,clrid varchar2(32) -- 押品编号
    ,contractno varchar2(50) -- 合同号
    ,balance number(20,2) -- 合同余额
    ,confmamt number(20,2) -- 我行确认价值
    ,firstconfmamt number(20,2) -- 初评我行确认价值
    ,distvalue number(20,2) -- 分配价值
    ,contguartype varchar2(6) -- 合同主担保方式
    ,guartype varchar2(32) -- 押品类型
    ,credittype varchar2(30) -- 业务品种
    ,barsign varchar2(3) -- 条线
    ,interindustry varchar2(10) -- 行业
    ,custscale varchar2(10) -- 规模
    ,reporttype varchar2(3) -- 表内表外标识
    ,deptcode varchar2(30) -- 所属机构
    ,fiveclass varchar2(6) -- 五级分类
    ,credno varchar2(40) -- 借据号
    ,bal number(16,2) -- 借据余额
    ,credlevel varchar2(10) -- 分配等级 1:一级分配 2:二级分配
    ,creditname varchar2(500) -- 业务品种名称
    ,occurtype varchar2(4) -- 发生类型
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_guardistributeforjour to ${iml_schema};
grant select on ${iol_schema}.icms_clr_guardistributeforjour to ${icl_schema};
grant select on ${iol_schema}.icms_clr_guardistributeforjour to ${idl_schema};
grant select on ${iol_schema}.icms_clr_guardistributeforjour to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_guardistributeforjour is 'G13缓释结果';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.datecode is '报表日期';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.contractno is '合同号';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.balance is '合同余额';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.confmamt is '我行确认价值';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.firstconfmamt is '初评我行确认价值';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.distvalue is '分配价值';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.contguartype is '合同主担保方式';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.guartype is '押品类型';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.credittype is '业务品种';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.barsign is '条线';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.interindustry is '行业';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.custscale is '规模';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.reporttype is '表内表外标识';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.deptcode is '所属机构';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.fiveclass is '五级分类';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.credno is '借据号';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.bal is '借据余额';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.credlevel is '分配等级 1:一级分配 2:二级分配';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.creditname is '业务品种名称';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.occurtype is '发生类型';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_guardistributeforjour.etl_timestamp is 'ETL处理时间戳';
