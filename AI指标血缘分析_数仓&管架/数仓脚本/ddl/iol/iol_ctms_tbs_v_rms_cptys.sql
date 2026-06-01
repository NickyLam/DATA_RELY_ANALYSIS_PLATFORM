/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_rms_cptys
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_rms_cptys
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_rms_cptys purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_rms_cptys(
    entyid varchar2(33) -- 交易对手编号
    ,pentyid varchar2(33) -- 父机构编号
    ,cmscounterpartyid varchar2(90) -- 对手id(cms)
    ,fmscounterpartyid varchar2(90) -- 对手id(xms)
    ,status varchar2(2) -- 状态
    ,ename varchar2(384) -- 英文名称
    ,sname varchar2(384) -- 中文短名
    ,esname varchar2(384) -- 英文短名
    ,contactname varchar2(90) -- 法人
    ,telephone varchar2(90) -- 电话
    ,fax varchar2(45) -- 传真
    ,label varchar2(96) -- 其他系统代号
    ,fdistid varchar2(30) -- 所在地区编号
    ,customertype varchar2(30) -- 行业类别编号
    ,ratinglevel number(22,0) -- 内部信用评级
    ,ratinglevelname varchar2(96) -- 内部信用评级名称
    ,excode varchar2(96) -- 电子联行号
    ,exaccount varchar2(96) -- 大额支付系统号
    ,trdpartcode varchar2(96) -- 第三方代码
    ,swiftcode varchar2(96) -- swift电文代号
    ,refissuerid varchar2(60) -- 发行/担保人
    ,isissuer varchar2(2) -- 是否发行人
    ,isbank varchar2(2) -- 是否金融机构
    ,isguarantee varchar2(2) -- 是否担保人
    ,iscustody varchar2(2) -- 是否托管机构
    ,cfetsmemberid varchar2(75) -- 本币会员id
    ,cfetsfxmemberid varchar2(75) -- 外汇会员id
    ,cfetsmemberattr varchar2(2) -- 会员来源
    ,entitytype varchar2(2) -- 是否母公司
    ,groupid varchar2(48) -- 母公司群组编号
    ,branchid number(8,0) -- 用户机构编号
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
grant select on ${iol_schema}.ctms_tbs_v_rms_cptys to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_rms_cptys to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_rms_cptys to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_rms_cptys to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_rms_cptys is 'RMS交易对手视图';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.entyid is '交易对手编号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.pentyid is '父机构编号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.cmscounterpartyid is '对手id(cms)';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.fmscounterpartyid is '对手id(xms)';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.status is '状态';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.ename is '英文名称';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.sname is '中文短名';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.esname is '英文短名';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.contactname is '法人';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.telephone is '电话';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.fax is '传真';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.label is '其他系统代号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.fdistid is '所在地区编号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.customertype is '行业类别编号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.ratinglevel is '内部信用评级';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.ratinglevelname is '内部信用评级名称';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.excode is '电子联行号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.exaccount is '大额支付系统号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.trdpartcode is '第三方代码';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.swiftcode is 'swift电文代号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.refissuerid is '发行/担保人';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.isissuer is '是否发行人';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.isbank is '是否金融机构';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.isguarantee is '是否担保人';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.iscustody is '是否托管机构';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.cfetsmemberid is '本币会员id';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.cfetsfxmemberid is '外汇会员id';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.cfetsmemberattr is '会员来源';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.entitytype is '是否母公司';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.groupid is '母公司群组编号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.branchid is '用户机构编号';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_rms_cptys.etl_timestamp is 'ETL处理时间戳';
