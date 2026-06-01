/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t00_organ
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t00_organ
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t00_organ purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t00_organ(
    organkey varchar2(18) -- 机构代码内部使用
    ,organno varchar2(48) -- 机构号
    ,organname varchar2(384) -- 机构名称
    ,organsf varchar2(384) -- 机构简称
    ,organlevel varchar2(2) -- 机构级别 0通用级，1总行级，2分行级，3支行级
    ,uporgankey varchar2(18) -- 上级机构为：1＝总行
    ,organaddress varchar2(750) -- 详细地址
    ,postalcode varchar2(9) -- 邮政编码
    ,telephone varchar2(48) -- 电话号码
    ,organmanager varchar2(48) -- 机构负责人
    ,organpamount number(22,0) -- 机构人数
    ,linkman varchar2(48) -- 联系人姓名
    ,builddate varchar2(48) -- 成立时间
    ,organdes varchar2(384) -- 提示标志 0正常，1新增标识，2未填写行政区划代码标识
    ,validatedate varchar2(36) -- 生效时间
    ,invalidatedate varchar2(36) -- 失效时间
    ,createdate varchar2(48) -- 创建时间
    ,creator varchar2(48) -- 创建人
    ,modifydate varchar2(48) -- 修改时间
    ,modifier varchar2(48) -- 修改人员
    ,flag varchar2(2) -- 标志位
    ,unionorgkey varchar2(30) -- 现代支付系统行号
    ,org_area varchar2(9) -- 行政区划代码
    ,settleorgkey varchar2(18) -- 人民币结算账户管理系统行号
    ,uporgankey_sor varchar2(192) -- 
    ,organcode varchar2(24) -- 机构编码
    ,is_cross varchar2(3) -- 跨境标识（境内10;境外11）
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
grant select on ${iol_schema}.amls_t00_organ to ${iml_schema};
grant select on ${iol_schema}.amls_t00_organ to ${icl_schema};
grant select on ${iol_schema}.amls_t00_organ to ${idl_schema};
grant select on ${iol_schema}.amls_t00_organ to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t00_organ is '机构表';
comment on column ${iol_schema}.amls_t00_organ.organkey is '机构代码内部使用';
comment on column ${iol_schema}.amls_t00_organ.organno is '机构号';
comment on column ${iol_schema}.amls_t00_organ.organname is '机构名称';
comment on column ${iol_schema}.amls_t00_organ.organsf is '机构简称';
comment on column ${iol_schema}.amls_t00_organ.organlevel is '机构级别 0通用级，1总行级，2分行级，3支行级';
comment on column ${iol_schema}.amls_t00_organ.uporgankey is '上级机构为：1＝总行';
comment on column ${iol_schema}.amls_t00_organ.organaddress is '详细地址';
comment on column ${iol_schema}.amls_t00_organ.postalcode is '邮政编码';
comment on column ${iol_schema}.amls_t00_organ.telephone is '电话号码';
comment on column ${iol_schema}.amls_t00_organ.organmanager is '机构负责人';
comment on column ${iol_schema}.amls_t00_organ.organpamount is '机构人数';
comment on column ${iol_schema}.amls_t00_organ.linkman is '联系人姓名';
comment on column ${iol_schema}.amls_t00_organ.builddate is '成立时间';
comment on column ${iol_schema}.amls_t00_organ.organdes is '提示标志 0正常，1新增标识，2未填写行政区划代码标识';
comment on column ${iol_schema}.amls_t00_organ.validatedate is '生效时间';
comment on column ${iol_schema}.amls_t00_organ.invalidatedate is '失效时间';
comment on column ${iol_schema}.amls_t00_organ.createdate is '创建时间';
comment on column ${iol_schema}.amls_t00_organ.creator is '创建人';
comment on column ${iol_schema}.amls_t00_organ.modifydate is '修改时间';
comment on column ${iol_schema}.amls_t00_organ.modifier is '修改人员';
comment on column ${iol_schema}.amls_t00_organ.flag is '标志位';
comment on column ${iol_schema}.amls_t00_organ.unionorgkey is '现代支付系统行号';
comment on column ${iol_schema}.amls_t00_organ.org_area is '行政区划代码';
comment on column ${iol_schema}.amls_t00_organ.settleorgkey is '人民币结算账户管理系统行号';
comment on column ${iol_schema}.amls_t00_organ.uporgankey_sor is '';
comment on column ${iol_schema}.amls_t00_organ.organcode is '机构编码';
comment on column ${iol_schema}.amls_t00_organ.is_cross is '跨境标识（境内10;境外11）';
comment on column ${iol_schema}.amls_t00_organ.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t00_organ.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t00_organ.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t00_organ.etl_timestamp is 'ETL处理时间戳';
