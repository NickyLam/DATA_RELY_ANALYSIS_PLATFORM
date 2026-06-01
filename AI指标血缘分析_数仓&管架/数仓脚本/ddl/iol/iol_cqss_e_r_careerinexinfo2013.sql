/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_e_r_careerinexinfo2013
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_e_r_careerinexinfo2013
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_e_r_careerinexinfo2013 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_e_r_careerinexinfo2013(
    id varchar2(96) -- 代码主键
    ,msgidno varchar2(53) -- 报文标识号
    ,multi_tenancy_id varchar2(30) -- 多实体标识
    ,cr_supr_rcrd_id varchar2(96) -- 征信上级记录编号(上级序号)
    ,fnc_alwc_crrov_srpls number(38,0) -- 本期财政补助结转结余:eg10bj01
    ,fnc_alwc_incm number(38,0) -- 财政补助收入:eg10bj02
    ,crer_expn number(38,0) -- 事业支出（财政补助支出）:eg10bj03
    ,crer_crrov_srpls number(38,0) -- 本期事业结转结余:eg10bj04
    ,crcgy_incm number(38,0) -- 事业类收入:eg10bj05
    ,crer_incm number(38,0) -- 事业收入:eg10bj06
    ,supr_alwc_incm number(38,0) -- 上级补助收入:eg10bj07
    ,aflt_unit_tnov_incm number(38,0) -- 附属单位上缴收入:eg10bj08
    ,oicm number(38,0) -- 其他收入:eg10bj09
    ,dntn_incm number(38,0) -- （其他收入科目下）捐赠收入:eg10bj10
    ,crcgy_expn number(38,0) -- 事业类支出:eg10bj11
    ,non_fnc_alwc_crer_expn number(38,0) -- 事业支出（非财政补助支出）:eg10bj12
    ,tnov_supr_expn number(38,0) -- 上缴上级支出:eg10bj13
    ,aflt_unit_alwc_expn number(38,0) -- 对附属单位补助支出:eg10bj14
    ,othexp number(38,0) -- 其他支出:eg10bj15
    ,crnprd_oprt_srpls number(38,0) -- 本期经营结余:eg10bj16
    ,oprt_incm number(38,0) -- 经营收入:eg10bj17
    ,oprt_expn number(38,0) -- 经营支出:eg10bj18
    ,flup_bfrls_afs_oprt_stlmt number(38,0) -- 弥补以前年度亏损后的经营结余:eg10bj19
    ,tsyr_non_fnc_crrov_srpls number(38,0) -- 本年非财政补助结转结余:eg10bj20
    ,non_fnc_crrov number(38,0) -- 非财政补助结转:eg10bj21
    ,tsyr_non_fnc_srpls number(38,0) -- 本年非财政补助结余:eg10bj22
    ,pbl_entp_incmtax number(38,0) -- 应缴企业所得税:eg10bj23
    ,rtrv_spclpps_fnd number(38,0) -- 提取专用基金:eg10bj24
    ,tfrin_crer_fnd number(38,0) -- 转入事业基金:eg10bj25
    ,crt_dt_tm date -- 创建日期时间
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
grant select on ${iol_schema}.cqss_e_r_careerinexinfo2013 to ${iml_schema};
grant select on ${iol_schema}.cqss_e_r_careerinexinfo2013 to ${icl_schema};
grant select on ${iol_schema}.cqss_e_r_careerinexinfo2013 to ${idl_schema};
grant select on ${iol_schema}.cqss_e_r_careerinexinfo2013 to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_e_r_careerinexinfo2013 is '事业单位收入支出表（2013 版）信息表';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.id is '代码主键';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.msgidno is '报文标识号';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.multi_tenancy_id is '多实体标识';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.cr_supr_rcrd_id is '征信上级记录编号(上级序号)';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.fnc_alwc_crrov_srpls is '本期财政补助结转结余:eg10bj01';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.fnc_alwc_incm is '财政补助收入:eg10bj02';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.crer_expn is '事业支出（财政补助支出）:eg10bj03';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.crer_crrov_srpls is '本期事业结转结余:eg10bj04';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.crcgy_incm is '事业类收入:eg10bj05';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.crer_incm is '事业收入:eg10bj06';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.supr_alwc_incm is '上级补助收入:eg10bj07';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.aflt_unit_tnov_incm is '附属单位上缴收入:eg10bj08';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.oicm is '其他收入:eg10bj09';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.dntn_incm is '（其他收入科目下）捐赠收入:eg10bj10';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.crcgy_expn is '事业类支出:eg10bj11';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.non_fnc_alwc_crer_expn is '事业支出（非财政补助支出）:eg10bj12';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.tnov_supr_expn is '上缴上级支出:eg10bj13';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.aflt_unit_alwc_expn is '对附属单位补助支出:eg10bj14';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.othexp is '其他支出:eg10bj15';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.crnprd_oprt_srpls is '本期经营结余:eg10bj16';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.oprt_incm is '经营收入:eg10bj17';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.oprt_expn is '经营支出:eg10bj18';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.flup_bfrls_afs_oprt_stlmt is '弥补以前年度亏损后的经营结余:eg10bj19';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.tsyr_non_fnc_crrov_srpls is '本年非财政补助结转结余:eg10bj20';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.non_fnc_crrov is '非财政补助结转:eg10bj21';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.tsyr_non_fnc_srpls is '本年非财政补助结余:eg10bj22';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.pbl_entp_incmtax is '应缴企业所得税:eg10bj23';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.rtrv_spclpps_fnd is '提取专用基金:eg10bj24';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.tfrin_crer_fnd is '转入事业基金:eg10bj25';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_e_r_careerinexinfo2013.etl_timestamp is 'ETL处理时间戳';
