/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ba_rel_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ba_rel_list
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ba_rel_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ba_rel_list(
    serialno varchar2(32) -- 主键
    ,relativeserialno varchar2(32) -- 业务流水号
    ,relpartneridno varchar2(32) -- 关联人配偶证件号码
    ,pledgepkno varchar2(32) -- 智贷质押物信息主键
    ,relidtype varchar2(10) -- 关联人证件类型
    ,relmarriage varchar2(10) -- 关联人婚姻状况
    ,relpartnername varchar2(100) -- 关联人配偶姓名
    ,updatedate date -- 更新时间
    ,ownshare number(16,9) -- 抵押人对抵押物拥有的份额
    ,businessesflag varchar2(2) -- 客户性质
    ,conshr number(5,2) -- 智贷权利人共有份额
    ,relpartneridtype varchar2(10) -- 关联人配偶证件类型
    ,cusid varchar2(32) -- 客户号
    ,naturecategoryrel varchar2(10) -- 关联人户籍性质
    ,reltyp varchar2(20) -- 关联人类型
    ,reltelno varchar2(20) -- 关联人手机号码
    ,relpartnertelno varchar2(20) -- 关联人配偶手机号码
    ,relidno varchar2(32) -- 关联人证件号码
    ,relname varchar2(100) -- 关联人姓名
    ,remark varchar2(300) -- 备注
    ,immovables varchar2(2) -- 不动产共有情况
    ,naturecategoryrelsps varchar2(10) -- 关联人配偶户籍性质
    ,eduexperiencerel varchar2(10) -- 关联人学历
    ,relfamilyaddr varchar2(200) -- 关联人居住地址
    ,fqzresult varchar2(3) -- 反欺诈结果
    ,zxresult varchar2(3) -- 征信结果
    ,agriflg varchar2(1) -- 是否农户
    ,relfamilycityid varchar2(10) -- 关联人居住地址城市编号
    ,oblityp varchar2(5) -- 智贷去权利人类型
    ,relrelationship varchar2(10) -- 与主借款人关系
    ,migtflag varchar2(80) -- 
    ,relidexpire date -- 关联人证件到期日
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
grant select on ${iol_schema}.icms_ba_rel_list to ${iml_schema};
grant select on ${iol_schema}.icms_ba_rel_list to ${icl_schema};
grant select on ${iol_schema}.icms_ba_rel_list to ${idl_schema};
grant select on ${iol_schema}.icms_ba_rel_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ba_rel_list is '房快贷关联人列表';
comment on column ${iol_schema}.icms_ba_rel_list.serialno is '主键';
comment on column ${iol_schema}.icms_ba_rel_list.relativeserialno is '业务流水号';
comment on column ${iol_schema}.icms_ba_rel_list.relpartneridno is '关联人配偶证件号码';
comment on column ${iol_schema}.icms_ba_rel_list.pledgepkno is '智贷质押物信息主键';
comment on column ${iol_schema}.icms_ba_rel_list.relidtype is '关联人证件类型';
comment on column ${iol_schema}.icms_ba_rel_list.relmarriage is '关联人婚姻状况';
comment on column ${iol_schema}.icms_ba_rel_list.relpartnername is '关联人配偶姓名';
comment on column ${iol_schema}.icms_ba_rel_list.updatedate is '更新时间';
comment on column ${iol_schema}.icms_ba_rel_list.ownshare is '抵押人对抵押物拥有的份额';
comment on column ${iol_schema}.icms_ba_rel_list.businessesflag is '客户性质';
comment on column ${iol_schema}.icms_ba_rel_list.conshr is '智贷权利人共有份额';
comment on column ${iol_schema}.icms_ba_rel_list.relpartneridtype is '关联人配偶证件类型';
comment on column ${iol_schema}.icms_ba_rel_list.cusid is '客户号';
comment on column ${iol_schema}.icms_ba_rel_list.naturecategoryrel is '关联人户籍性质';
comment on column ${iol_schema}.icms_ba_rel_list.reltyp is '关联人类型';
comment on column ${iol_schema}.icms_ba_rel_list.reltelno is '关联人手机号码';
comment on column ${iol_schema}.icms_ba_rel_list.relpartnertelno is '关联人配偶手机号码';
comment on column ${iol_schema}.icms_ba_rel_list.relidno is '关联人证件号码';
comment on column ${iol_schema}.icms_ba_rel_list.relname is '关联人姓名';
comment on column ${iol_schema}.icms_ba_rel_list.remark is '备注';
comment on column ${iol_schema}.icms_ba_rel_list.immovables is '不动产共有情况';
comment on column ${iol_schema}.icms_ba_rel_list.naturecategoryrelsps is '关联人配偶户籍性质';
comment on column ${iol_schema}.icms_ba_rel_list.eduexperiencerel is '关联人学历';
comment on column ${iol_schema}.icms_ba_rel_list.relfamilyaddr is '关联人居住地址';
comment on column ${iol_schema}.icms_ba_rel_list.fqzresult is '反欺诈结果';
comment on column ${iol_schema}.icms_ba_rel_list.zxresult is '征信结果';
comment on column ${iol_schema}.icms_ba_rel_list.agriflg is '是否农户';
comment on column ${iol_schema}.icms_ba_rel_list.relfamilycityid is '关联人居住地址城市编号';
comment on column ${iol_schema}.icms_ba_rel_list.oblityp is '智贷去权利人类型';
comment on column ${iol_schema}.icms_ba_rel_list.relrelationship is '与主借款人关系';
comment on column ${iol_schema}.icms_ba_rel_list.migtflag is '';
comment on column ${iol_schema}.icms_ba_rel_list.relidexpire is '关联人证件到期日';
comment on column ${iol_schema}.icms_ba_rel_list.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ba_rel_list.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ba_rel_list.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ba_rel_list.etl_timestamp is 'ETL处理时间戳';
