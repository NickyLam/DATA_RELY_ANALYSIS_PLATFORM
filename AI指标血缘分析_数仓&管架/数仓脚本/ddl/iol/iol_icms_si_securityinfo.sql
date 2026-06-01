/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_si_securityinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_si_securityinfo
whenever sqlerror continue none;
drop table ${iol_schema}.icms_si_securityinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_si_securityinfo(
    sccode varchar2(32) -- 押品编号
    ,guartype varchar2(32) -- 押品类型编号
    ,createuser varchar2(20) -- 押品主管(创建人)
    ,deptcode varchar2(20) -- 押品所属机构
    ,createdate varchar2(30) -- 建立时间
    ,conominium varchar2(3) -- 是否共同财产 C0101，0 否、1 是
    ,conshare number(5,2) -- 抵质押品权利人所占份额
    ,effecttype varchar2(2) -- 担保生效方式 对应字典编号DBSXFS，业务字典：01-抵质押登记，02-移交占有生效，03-冻结/止付生效，99-其它
    ,isinsure varchar2(3) -- 是否需要办理保险 C0101，  0 否、1 是
    ,guaregisterstate varchar2(2) -- 押品登记办理状态 1072，  01 未办理，  02 已办理
    ,guainsurestate varchar2(2) -- 押品保险办理状态 1073，  01 有效，  02 失效
    ,state varchar2(2) -- 押品入库状态 0715，01未入库，02已入库，03已临时出库，04待出库，05已出库，06遗失/灭失
    ,usestate varchar2(2) -- 押品关联状态 YP300，01-已创建，02-授信审批中，03-与授信关联，04-与业务关联，05-清收处置
    ,guaspecialstate varchar2(2) -- 押品状态
    ,bxability varchar2(3) -- 权重法变现能力 BXNL， 0 低， 1 高
    ,isotherguar varchar2(3) -- 是否他行担保 C0101，0 否、1 是
    ,isgencust varchar2(3) -- 是否代保管 C0101，0 否、1 是
    ,confmamt number(20,2) -- 我行确认价值
    ,confmcurrency varchar2(3) -- 我行确认价值币种代码 对应字典编号0302
    ,evaldate varchar2(30) -- 评估时间
    ,datasourceflag varchar2(3) -- 数据来源标志 对应字典编号：1084，1-从信贷抽取，2-押品系统新增 3 从零售信贷移植
    ,exapstate varchar2(3) -- 押品信息审核状态 对应字典编号1057，  押品信息审批状态，  内部字典：，  0-未审批，  1-审批中，  2-已审批，  根据押品信息审核流程确定。
    ,editstate varchar2(3) -- 押品修改审批状态（普通修改，特殊修改） 对应字典编号1058，押品信息修改审批状态，内部字典：，0-未修改，1-修改审批中，修改审批通过或否决 该状态置为0
    ,bxability2 varchar2(3) -- 初级内评法变现能力
    ,isgain varchar2(3) -- 是否取得关键信息
    ,ismodify varchar2(3) -- 是否可修改
    ,guarinfoname varchar2(200) -- 押品名称
    ,controlchange varchar2(2) -- 质押物控制力调整系数 CONTROLCHANGE
    ,updates varchar2(10) -- 最新修改日期
    ,upduser varchar2(20) -- 最新修改人
    ,issaveowner varchar2(3) -- 是否保存我行
    ,guarsign varchar2(2) -- 抵制押品标识 C0108 01:有实物，风管, 02:有实物，营运,03:无实物
    ,issequence varchar2(3) -- 是否第一顺位 C0101   0 否、1 是
    ,ismulti varchar2(3) -- 是否二押 C0101  0 否、1 是
    ,amount number(20,2) -- 优先受偿权数额
    ,investsignage varchar2(3) -- 投资类标识 1 是  否
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
grant select on ${iol_schema}.icms_si_securityinfo to ${iml_schema};
grant select on ${iol_schema}.icms_si_securityinfo to ${icl_schema};
grant select on ${iol_schema}.icms_si_securityinfo to ${idl_schema};
grant select on ${iol_schema}.icms_si_securityinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_si_securityinfo is '押品基本信息';
comment on column ${iol_schema}.icms_si_securityinfo.sccode is '押品编号';
comment on column ${iol_schema}.icms_si_securityinfo.guartype is '押品类型编号';
comment on column ${iol_schema}.icms_si_securityinfo.createuser is '押品主管(创建人)';
comment on column ${iol_schema}.icms_si_securityinfo.deptcode is '押品所属机构';
comment on column ${iol_schema}.icms_si_securityinfo.createdate is '建立时间';
comment on column ${iol_schema}.icms_si_securityinfo.conominium is '是否共同财产 C0101，0 否、1 是';
comment on column ${iol_schema}.icms_si_securityinfo.conshare is '抵质押品权利人所占份额';
comment on column ${iol_schema}.icms_si_securityinfo.effecttype is '担保生效方式 对应字典编号DBSXFS，业务字典：01-抵质押登记，02-移交占有生效，03-冻结/止付生效，99-其它';
comment on column ${iol_schema}.icms_si_securityinfo.isinsure is '是否需要办理保险 C0101，  0 否、1 是';
comment on column ${iol_schema}.icms_si_securityinfo.guaregisterstate is '押品登记办理状态 1072，  01 未办理，  02 已办理';
comment on column ${iol_schema}.icms_si_securityinfo.guainsurestate is '押品保险办理状态 1073，  01 有效，  02 失效';
comment on column ${iol_schema}.icms_si_securityinfo.state is '押品入库状态 0715，01未入库，02已入库，03已临时出库，04待出库，05已出库，06遗失/灭失';
comment on column ${iol_schema}.icms_si_securityinfo.usestate is '押品关联状态 YP300，01-已创建，02-授信审批中，03-与授信关联，04-与业务关联，05-清收处置';
comment on column ${iol_schema}.icms_si_securityinfo.guaspecialstate is '押品状态';
comment on column ${iol_schema}.icms_si_securityinfo.bxability is '权重法变现能力 BXNL， 0 低， 1 高';
comment on column ${iol_schema}.icms_si_securityinfo.isotherguar is '是否他行担保 C0101，0 否、1 是';
comment on column ${iol_schema}.icms_si_securityinfo.isgencust is '是否代保管 C0101，0 否、1 是';
comment on column ${iol_schema}.icms_si_securityinfo.confmamt is '我行确认价值';
comment on column ${iol_schema}.icms_si_securityinfo.confmcurrency is '我行确认价值币种代码 对应字典编号0302';
comment on column ${iol_schema}.icms_si_securityinfo.evaldate is '评估时间';
comment on column ${iol_schema}.icms_si_securityinfo.datasourceflag is '数据来源标志 对应字典编号：1084，1-从信贷抽取，2-押品系统新增 3 从零售信贷移植';
comment on column ${iol_schema}.icms_si_securityinfo.exapstate is '押品信息审核状态 对应字典编号1057，  押品信息审批状态，  内部字典：，  0-未审批，  1-审批中，  2-已审批，  根据押品信息审核流程确定。';
comment on column ${iol_schema}.icms_si_securityinfo.editstate is '押品修改审批状态（普通修改，特殊修改） 对应字典编号1058，押品信息修改审批状态，内部字典：，0-未修改，1-修改审批中，修改审批通过或否决 该状态置为0';
comment on column ${iol_schema}.icms_si_securityinfo.bxability2 is '初级内评法变现能力';
comment on column ${iol_schema}.icms_si_securityinfo.isgain is '是否取得关键信息';
comment on column ${iol_schema}.icms_si_securityinfo.ismodify is '是否可修改';
comment on column ${iol_schema}.icms_si_securityinfo.guarinfoname is '押品名称';
comment on column ${iol_schema}.icms_si_securityinfo.controlchange is '质押物控制力调整系数 CONTROLCHANGE';
comment on column ${iol_schema}.icms_si_securityinfo.updates is '最新修改日期';
comment on column ${iol_schema}.icms_si_securityinfo.upduser is '最新修改人';
comment on column ${iol_schema}.icms_si_securityinfo.issaveowner is '是否保存我行';
comment on column ${iol_schema}.icms_si_securityinfo.guarsign is '抵制押品标识 C0108 01:有实物，风管, 02:有实物，营运,03:无实物';
comment on column ${iol_schema}.icms_si_securityinfo.issequence is '是否第一顺位 C0101   0 否、1 是';
comment on column ${iol_schema}.icms_si_securityinfo.ismulti is '是否二押 C0101  0 否、1 是';
comment on column ${iol_schema}.icms_si_securityinfo.amount is '优先受偿权数额';
comment on column ${iol_schema}.icms_si_securityinfo.investsignage is '投资类标识 1 是  否';
comment on column ${iol_schema}.icms_si_securityinfo.start_dt is '开始时间';
comment on column ${iol_schema}.icms_si_securityinfo.end_dt is '结束时间';
comment on column ${iol_schema}.icms_si_securityinfo.id_mark is '增删标志';
comment on column ${iol_schema}.icms_si_securityinfo.etl_timestamp is 'ETL处理时间戳';
