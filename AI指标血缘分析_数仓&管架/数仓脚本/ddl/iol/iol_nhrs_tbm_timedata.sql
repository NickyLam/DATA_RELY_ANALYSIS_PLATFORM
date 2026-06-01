/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_tbm_timedata
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_tbm_timedata
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_tbm_timedata purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_tbm_timedata(
    calendar varchar2(10) -- 
    ,creationtime varchar2(19) -- 
    ,creator varchar2(20) -- 
    ,dirty_flag varchar2(1) -- 
    ,dr number(10,0) -- 
    ,fourabsentlen number(16,4) -- 
    ,fourbegintime varchar2(19) -- 
    ,fourearlylen number(16,4) -- 
    ,fourendtime varchar2(19) -- 
    ,fourisabsent number(38,0) -- 
    ,fourisearly number(38,0) -- 
    ,fourisearlyabsent number(38,0) -- 
    ,fourislate number(38,0) -- 
    ,fourislateabsent number(38,0) -- 
    ,fourlatelen number(16,4) -- 
    ,fournightlen number(16,4) -- 
    ,fouruselactationholidaylen number(16,4) -- 
    ,fourworklen number(16,4) -- 
    ,fourworklen_hol number(16,4) -- 
    ,importsignflag number(38,0) -- 
    ,ismidoutabnormal varchar2(1) -- 
    ,ismidwayout number(38,0) -- 
    ,midwayoutcount number(38,0) -- 
    ,midwayouttime number(16,4) -- 
    ,modifiedtime varchar2(19) -- 
    ,modifier varchar2(20) -- 
    ,nightlength number(16,4) -- 
    ,nightlength_cur number(16,4) -- 
    ,nightlength_next number(16,4) -- 
    ,nightlength_previous number(16,4) -- 
    ,oneabsentlen number(16,4) -- 
    ,onebegintime varchar2(19) -- 
    ,oneearlylen number(16,4) -- 
    ,oneendtime varchar2(19) -- 
    ,oneisabsent number(38,0) -- 
    ,oneisearly number(38,0) -- 
    ,oneisearlyabsent number(38,0) -- 
    ,oneislate number(38,0) -- 
    ,oneislateabsent number(38,0) -- 
    ,onelatelen number(16,4) -- 
    ,onenightlen number(16,4) -- 
    ,oneuselactationholidaylen number(16,4) -- 
    ,oneworklen number(16,4) -- 
    ,oneworklen_hol number(16,4) -- 
    ,pk_fourbeginmachine varchar2(20) -- 
    ,pk_fourbeginplace varchar2(20) -- 
    ,pk_fourendmachine varchar2(20) -- 
    ,pk_fourendplace varchar2(20) -- 
    ,pk_group varchar2(20) -- 
    ,pk_onebeginmachine varchar2(20) -- 
    ,pk_onebeginplace varchar2(20) -- 
    ,pk_oneendmachine varchar2(20) -- 
    ,pk_oneendplace varchar2(20) -- 
    ,pk_org varchar2(20) -- 
    ,pk_psndoc varchar2(20) -- 
    ,pk_threebeginmachine varchar2(20) -- 
    ,pk_threebeginplace varchar2(20) -- 
    ,pk_threeendmachine varchar2(20) -- 
    ,pk_threeendplace varchar2(20) -- 
    ,pk_timedata varchar2(20) -- 
    ,pk_twobeginmachine varchar2(20) -- 
    ,pk_twobeginplace varchar2(20) -- 
    ,pk_twoendmachine varchar2(20) -- 
    ,pk_twoendplace varchar2(20) -- 
    ,placeabnormal number(38,0) -- 
    ,tbmstatus varchar2(128) -- 
    ,threeabsentlen number(16,4) -- 
    ,threebegintime varchar2(19) -- 
    ,threeearlylen number(16,4) -- 
    ,threeendtime varchar2(19) -- 
    ,threeisabsent number(38,0) -- 
    ,threeisearly number(38,0) -- 
    ,threeisearlyabsent number(38,0) -- 
    ,threeislate number(38,0) -- 
    ,threeislateabsent number(38,0) -- 
    ,threelatelen number(16,4) -- 
    ,threenightlen number(16,4) -- 
    ,threeuselactationholidaylen number(16,4) -- 
    ,threeworklen number(16,4) -- 
    ,threeworklen_hol number(16,4) -- 
    ,ts varchar2(19) -- 
    ,twoabsentlen number(16,4) -- 
    ,twobegintime varchar2(19) -- 
    ,twoearlylen number(16,4) -- 
    ,twoendtime varchar2(19) -- 
    ,twoisabsent number(38,0) -- 
    ,twoisearly number(38,0) -- 
    ,twoisearlyabsent number(38,0) -- 
    ,twoislate number(38,0) -- 
    ,twoislateabsent number(38,0) -- 
    ,twolatelen number(16,4) -- 
    ,twonightlen number(16,4) -- 
    ,twouselactationholidaylen number(16,4) -- 
    ,twoworklen number(16,4) -- 
    ,twoworklen_hol number(16,4) -- 
    ,worklength number(16,4) -- 
    ,worklength_cur number(16,4) -- 
    ,worklength_cur_hol number(16,4) -- 
    ,worklength_hol number(16,4) -- 
    ,worklength_next number(16,4) -- 
    ,worklength_next_hol number(16,4) -- 
    ,worklength_previous number(16,4) -- 
    ,worklength_previous_hol number(16,4) -- 
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
grant select on ${iol_schema}.nhrs_tbm_timedata to ${iml_schema};
grant select on ${iol_schema}.nhrs_tbm_timedata to ${icl_schema};
grant select on ${iol_schema}.nhrs_tbm_timedata to ${idl_schema};
grant select on ${iol_schema}.nhrs_tbm_timedata to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_tbm_timedata is '机器考勤数据';
comment on column ${iol_schema}.nhrs_tbm_timedata.calendar is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.creationtime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.creator is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.dirty_flag is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.dr is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourabsentlen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourbegintime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourearlylen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourendtime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourisabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourisearly is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourisearlyabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourislate is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourislateabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourlatelen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fournightlen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fouruselactationholidaylen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourworklen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.fourworklen_hol is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.importsignflag is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.ismidoutabnormal is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.ismidwayout is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.midwayoutcount is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.midwayouttime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.modifiedtime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.modifier is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.nightlength is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.nightlength_cur is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.nightlength_next is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.nightlength_previous is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneabsentlen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.onebegintime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneearlylen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneendtime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneisabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneisearly is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneisearlyabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneislate is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneislateabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.onelatelen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.onenightlen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneuselactationholidaylen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneworklen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.oneworklen_hol is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_fourbeginmachine is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_fourbeginplace is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_fourendmachine is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_fourendplace is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_group is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_onebeginmachine is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_onebeginplace is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_oneendmachine is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_oneendplace is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_org is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_psndoc is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_threebeginmachine is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_threebeginplace is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_threeendmachine is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_threeendplace is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_timedata is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_twobeginmachine is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_twobeginplace is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_twoendmachine is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.pk_twoendplace is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.placeabnormal is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.tbmstatus is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeabsentlen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threebegintime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeearlylen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeendtime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeisabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeisearly is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeisearlyabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeislate is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeislateabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threelatelen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threenightlen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeuselactationholidaylen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeworklen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.threeworklen_hol is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.ts is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twoabsentlen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twobegintime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twoearlylen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twoendtime is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twoisabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twoisearly is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twoisearlyabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twoislate is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twoislateabsent is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twolatelen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twonightlen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twouselactationholidaylen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twoworklen is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.twoworklen_hol is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.worklength is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.worklength_cur is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.worklength_cur_hol is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.worklength_hol is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.worklength_next is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.worklength_next_hol is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.worklength_previous is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.worklength_previous_hol is '';
comment on column ${iol_schema}.nhrs_tbm_timedata.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_tbm_timedata.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_tbm_timedata.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_tbm_timedata.etl_timestamp is 'ETL处理时间戳';
