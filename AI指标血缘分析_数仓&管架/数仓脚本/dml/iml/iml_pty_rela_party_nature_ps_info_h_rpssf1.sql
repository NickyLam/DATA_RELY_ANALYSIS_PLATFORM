/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_rela_party_nature_ps_info_h_rpssf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_rela_party_nature_ps_info_h add partition p_rpssf1 values ('rpssf1')(
        subpartition p_rpssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_rpssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_rela_party_nature_ps_info_h partition for ('rpssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_tm purge;
drop table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_op purge;
drop table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_tm nologging
compress ${option_switch} for query high
as select
    rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,name -- 姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,kins_cls_cd -- 近亲属分类代码
    ,belong_org_cd -- 所属机构代码
    ,ghb_jobs_or_post_descb -- 本行岗位或职务描述
    ,dimission_tm -- 离职时间
    ,rela_corp_name -- 关联单位名称
    ,pos -- 担任职务
    ,share_ratio -- 持股比例
    ,remark -- 备注
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,cert_type_cd_2 -- 证件类型代码2
    ,cert_no_2 -- 证件号码2
    ,belong_org_id -- 归属机构编号
    ,matn_org_id -- 维护机构编号
    ,dom_overs_flg_1 -- 境内外标志1
    ,dom_overs_flg_2 -- 境内外标志2
    ,shard_or_rela_party_type_cd -- 股东或关联方类型代码
    ,shard_or_rela_party_bl_induty_type_cd -- 股东或关联方所属行业类型代码
    ,shard_or_rela_party_rgst -- 股东或关联方注册地
    ,shard_or_rela_party_rela_type_cd -- 股东或关联方关系类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_rela_party_nature_ps_info_h partition for ('rpssf1')
where 0=1
;

create table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_rela_party_nature_ps_info_h partition for ('rpssf1') where 0=1;

create table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_rela_party_nature_ps_info_h partition for ('rpssf1') where 0=1;

-- 3.1 get new data into table
-- rpss_related_person-
insert into ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_tm(
    rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,name -- 姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,kins_cls_cd -- 近亲属分类代码
    ,belong_org_cd -- 所属机构代码
    ,ghb_jobs_or_post_descb -- 本行岗位或职务描述
    ,dimission_tm -- 离职时间
    ,rela_corp_name -- 关联单位名称
    ,pos -- 担任职务
    ,share_ratio -- 持股比例
    ,remark -- 备注
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,cert_type_cd_2 -- 证件类型代码2
    ,cert_no_2 -- 证件号码2
    ,belong_org_id -- 归属机构编号
    ,matn_org_id -- 维护机构编号
    ,dom_overs_flg_1 -- 境内外标志1
    ,dom_overs_flg_2 -- 境内外标志2
    ,shard_or_rela_party_type_cd -- 股东或关联方类型代码
    ,shard_or_rela_party_bl_induty_type_cd -- 股东或关联方所属行业类型代码
    ,shard_or_rela_party_rgst -- 股东或关联方注册地
    ,shard_or_rela_party_rela_type_cd -- 股东或关联方关系类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.RELATED_ID -- 关联方编号
    ,'9999' -- 法人编号
    ,P1.PERSON_NAME -- 姓名
    ,P1.CERTIFICATE_TYPE_ID -- 证件类型代码
    ,P1.CERTIFICATE_NO -- 证件号码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.KINSHIP END -- 近亲属分类代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ORGANIZATION END -- 所属机构代码
    ,P1.DUTY -- 本行岗位或职务描述
    ,P1.DIMISSION_DATE -- 离职时间
    ,P1.RELATED_UNIT -- 关联单位名称
    ,P1.RELATED_DUTY -- 担任职务
    ,P1.SHAREHOLDING_RATIO -- 持股比例
    ,P1.COMMENTS -- 备注
    ,P1.LAST_UPDATED_STAMP -- 最后更新时间
    ,P1.LAST_UPDATED_TX_STAMP -- 最后更新事务时间
    ,P1.CREATED_STAMP -- 创建时间
    ,P1.CREATED_TX_STAMP -- 创建事务时间
    ,nvl(trim(P1.CERTIFICATE_TYPE_ID_T),'0000')  -- 证件类型代码2
    ,P1.CERTIFICATE_NO_T -- 证件号码2
    ,P1.BELONG_ORG -- 归属机构编号
    ,P1.MAINTEN_ORG -- 维护机构编号
    ,nvl(trim(P1.DOMESTIC_OR_FOREIGN),'0') -- 境内外标志1
    ,nvl(trim(P1.DOMESTIC_OR_FOREIGN_T),'0') -- 境内外标志2
    ,nvl(trim(P1.HOLD_RELATED_TYPE),'-')  -- 股东或关联方类型代码
    ,nvl(trim(P1.HOLD_RELATED_INDUSTRY),'-')  -- 股东或关联方所属行业类型代码
    ,P1.HOLD_RELATED_REG_ADDRESS -- 股东或关联方注册地
    ,nvl(trim(P1.HOLD_RELATED_REL_TYPE),'-') -- 股东或关联方关系类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rpss_related_person' -- 源表名称
    ,'rpssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rpss_related_person p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.KINSHIP = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'RPSS'
        AND R1.SRC_TAB_EN_NAME= 'RPSS_RELATED_PERSON'
        AND R1.SRC_FIELD_EN_NAME= 'KINSHIP'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_RELA_PARTY_NATURE_PS_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'KINS_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ORGANIZATION = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'RPSS'
        AND R2.SRC_TAB_EN_NAME= 'RPSS_RELATED_PERSON'
        AND R2.SRC_FIELD_EN_NAME= 'ORGANIZATION'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_RELA_PARTY_NATURE_PS_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BELONG_ORG_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_tm 
  	                                group by 
  	                                        rela_party_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_cl(
            rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,name -- 姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,kins_cls_cd -- 近亲属分类代码
    ,belong_org_cd -- 所属机构代码
    ,ghb_jobs_or_post_descb -- 本行岗位或职务描述
    ,dimission_tm -- 离职时间
    ,rela_corp_name -- 关联单位名称
    ,pos -- 担任职务
    ,share_ratio -- 持股比例
    ,remark -- 备注
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,cert_type_cd_2 -- 证件类型代码2
    ,cert_no_2 -- 证件号码2
    ,belong_org_id -- 归属机构编号
    ,matn_org_id -- 维护机构编号
    ,dom_overs_flg_1 -- 境内外标志1
    ,dom_overs_flg_2 -- 境内外标志2
    ,shard_or_rela_party_type_cd -- 股东或关联方类型代码
    ,shard_or_rela_party_bl_induty_type_cd -- 股东或关联方所属行业类型代码
    ,shard_or_rela_party_rgst -- 股东或关联方注册地
    ,shard_or_rela_party_rela_type_cd -- 股东或关联方关系类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_op(
            rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,name -- 姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,kins_cls_cd -- 近亲属分类代码
    ,belong_org_cd -- 所属机构代码
    ,ghb_jobs_or_post_descb -- 本行岗位或职务描述
    ,dimission_tm -- 离职时间
    ,rela_corp_name -- 关联单位名称
    ,pos -- 担任职务
    ,share_ratio -- 持股比例
    ,remark -- 备注
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,cert_type_cd_2 -- 证件类型代码2
    ,cert_no_2 -- 证件号码2
    ,belong_org_id -- 归属机构编号
    ,matn_org_id -- 维护机构编号
    ,dom_overs_flg_1 -- 境内外标志1
    ,dom_overs_flg_2 -- 境内外标志2
    ,shard_or_rela_party_type_cd -- 股东或关联方类型代码
    ,shard_or_rela_party_bl_induty_type_cd -- 股东或关联方所属行业类型代码
    ,shard_or_rela_party_rgst -- 股东或关联方注册地
    ,shard_or_rela_party_rela_type_cd -- 股东或关联方关系类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rela_party_id, o.rela_party_id) as rela_party_id -- 关联方编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.kins_cls_cd, o.kins_cls_cd) as kins_cls_cd -- 近亲属分类代码
    ,nvl(n.belong_org_cd, o.belong_org_cd) as belong_org_cd -- 所属机构代码
    ,nvl(n.ghb_jobs_or_post_descb, o.ghb_jobs_or_post_descb) as ghb_jobs_or_post_descb -- 本行岗位或职务描述
    ,nvl(n.dimission_tm, o.dimission_tm) as dimission_tm -- 离职时间
    ,nvl(n.rela_corp_name, o.rela_corp_name) as rela_corp_name -- 关联单位名称
    ,nvl(n.pos, o.pos) as pos -- 担任职务
    ,nvl(n.share_ratio, o.share_ratio) as share_ratio -- 持股比例
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.final_update_tm, o.final_update_tm) as final_update_tm -- 最后更新时间
    ,nvl(n.final_update_affair_tm, o.final_update_affair_tm) as final_update_affair_tm -- 最后更新事务时间
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.create_affair_tm, o.create_affair_tm) as create_affair_tm -- 创建事务时间
    ,nvl(n.cert_type_cd_2, o.cert_type_cd_2) as cert_type_cd_2 -- 证件类型代码2
    ,nvl(n.cert_no_2, o.cert_no_2) as cert_no_2 -- 证件号码2
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 归属机构编号
    ,nvl(n.matn_org_id, o.matn_org_id) as matn_org_id -- 维护机构编号
    ,nvl(n.dom_overs_flg_1, o.dom_overs_flg_1) as dom_overs_flg_1 -- 境内外标志1
    ,nvl(n.dom_overs_flg_2, o.dom_overs_flg_2) as dom_overs_flg_2 -- 境内外标志2
    ,nvl(n.shard_or_rela_party_type_cd, o.shard_or_rela_party_type_cd) as shard_or_rela_party_type_cd -- 股东或关联方类型代码
    ,nvl(n.shard_or_rela_party_bl_induty_type_cd, o.shard_or_rela_party_bl_induty_type_cd) as shard_or_rela_party_bl_induty_type_cd -- 股东或关联方所属行业类型代码
    ,nvl(n.shard_or_rela_party_rgst, o.shard_or_rela_party_rgst) as shard_or_rela_party_rgst -- 股东或关联方注册地
    ,nvl(n.shard_or_rela_party_rela_type_cd, o.shard_or_rela_party_rela_type_cd) as shard_or_rela_party_rela_type_cd -- 股东或关联方关系类型代码
    ,case when
            n.rela_party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rela_party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rela_party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_tm n
    full join (select * from ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.rela_party_id = n.rela_party_id
            and o.lp_id = n.lp_id
where (
        o.rela_party_id is null
        and o.lp_id is null
    )
    or (
        n.rela_party_id is null
        and n.lp_id is null
    )
    or (
        o.name <> n.name
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.kins_cls_cd <> n.kins_cls_cd
        or o.belong_org_cd <> n.belong_org_cd
        or o.ghb_jobs_or_post_descb <> n.ghb_jobs_or_post_descb
        or o.dimission_tm <> n.dimission_tm
        or o.rela_corp_name <> n.rela_corp_name
        or o.pos <> n.pos
        or o.share_ratio <> n.share_ratio
        or o.remark <> n.remark
        or o.final_update_tm <> n.final_update_tm
        or o.final_update_affair_tm <> n.final_update_affair_tm
        or o.create_tm <> n.create_tm
        or o.create_affair_tm <> n.create_affair_tm
        or o.cert_type_cd_2 <> n.cert_type_cd_2
        or o.cert_no_2 <> n.cert_no_2
        or o.belong_org_id <> n.belong_org_id
        or o.matn_org_id <> n.matn_org_id
        or o.dom_overs_flg_1 <> n.dom_overs_flg_1
        or o.dom_overs_flg_2 <> n.dom_overs_flg_2
        or o.shard_or_rela_party_type_cd <> n.shard_or_rela_party_type_cd
        or o.shard_or_rela_party_bl_induty_type_cd <> n.shard_or_rela_party_bl_induty_type_cd
        or o.shard_or_rela_party_rgst <> n.shard_or_rela_party_rgst
        or o.shard_or_rela_party_rela_type_cd <> n.shard_or_rela_party_rela_type_cd
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_cl(
            rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,name -- 姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,kins_cls_cd -- 近亲属分类代码
    ,belong_org_cd -- 所属机构代码
    ,ghb_jobs_or_post_descb -- 本行岗位或职务描述
    ,dimission_tm -- 离职时间
    ,rela_corp_name -- 关联单位名称
    ,pos -- 担任职务
    ,share_ratio -- 持股比例
    ,remark -- 备注
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,cert_type_cd_2 -- 证件类型代码2
    ,cert_no_2 -- 证件号码2
    ,belong_org_id -- 归属机构编号
    ,matn_org_id -- 维护机构编号
    ,dom_overs_flg_1 -- 境内外标志1
    ,dom_overs_flg_2 -- 境内外标志2
    ,shard_or_rela_party_type_cd -- 股东或关联方类型代码
    ,shard_or_rela_party_bl_induty_type_cd -- 股东或关联方所属行业类型代码
    ,shard_or_rela_party_rgst -- 股东或关联方注册地
    ,shard_or_rela_party_rela_type_cd -- 股东或关联方关系类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_op(
            rela_party_id -- 关联方编号
    ,lp_id -- 法人编号
    ,name -- 姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,kins_cls_cd -- 近亲属分类代码
    ,belong_org_cd -- 所属机构代码
    ,ghb_jobs_or_post_descb -- 本行岗位或职务描述
    ,dimission_tm -- 离职时间
    ,rela_corp_name -- 关联单位名称
    ,pos -- 担任职务
    ,share_ratio -- 持股比例
    ,remark -- 备注
    ,final_update_tm -- 最后更新时间
    ,final_update_affair_tm -- 最后更新事务时间
    ,create_tm -- 创建时间
    ,create_affair_tm -- 创建事务时间
    ,cert_type_cd_2 -- 证件类型代码2
    ,cert_no_2 -- 证件号码2
    ,belong_org_id -- 归属机构编号
    ,matn_org_id -- 维护机构编号
    ,dom_overs_flg_1 -- 境内外标志1
    ,dom_overs_flg_2 -- 境内外标志2
    ,shard_or_rela_party_type_cd -- 股东或关联方类型代码
    ,shard_or_rela_party_bl_induty_type_cd -- 股东或关联方所属行业类型代码
    ,shard_or_rela_party_rgst -- 股东或关联方注册地
    ,shard_or_rela_party_rela_type_cd -- 股东或关联方关系类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rela_party_id -- 关联方编号
    ,o.lp_id -- 法人编号
    ,o.name -- 姓名
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.kins_cls_cd -- 近亲属分类代码
    ,o.belong_org_cd -- 所属机构代码
    ,o.ghb_jobs_or_post_descb -- 本行岗位或职务描述
    ,o.dimission_tm -- 离职时间
    ,o.rela_corp_name -- 关联单位名称
    ,o.pos -- 担任职务
    ,o.share_ratio -- 持股比例
    ,o.remark -- 备注
    ,o.final_update_tm -- 最后更新时间
    ,o.final_update_affair_tm -- 最后更新事务时间
    ,o.create_tm -- 创建时间
    ,o.create_affair_tm -- 创建事务时间
    ,o.cert_type_cd_2 -- 证件类型代码2
    ,o.cert_no_2 -- 证件号码2
    ,o.belong_org_id -- 归属机构编号
    ,o.matn_org_id -- 维护机构编号
    ,o.dom_overs_flg_1 -- 境内外标志1
    ,o.dom_overs_flg_2 -- 境内外标志2
    ,o.shard_or_rela_party_type_cd -- 股东或关联方类型代码
    ,o.shard_or_rela_party_bl_induty_type_cd -- 股东或关联方所属行业类型代码
    ,o.shard_or_rela_party_rgst -- 股东或关联方注册地
    ,o.shard_or_rela_party_rela_type_cd -- 股东或关联方关系类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_bk o
    left join ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_op n
        on
            o.rela_party_id = n.rela_party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_cl d
        on
            o.rela_party_id = d.rela_party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_rela_party_nature_ps_info_h;
--alter table ${iml_schema}.pty_rela_party_nature_ps_info_h truncate partition for ('rpssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_rela_party_nature_ps_info_h') 
               and substr(subpartition_name,1,8)=upper('p_rpssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_rela_party_nature_ps_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.pty_rela_party_nature_ps_info_h modify partition p_rpssf1 
add subpartition p_rpssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_rela_party_nature_ps_info_h exchange subpartition p_rpssf1_${batch_date} with table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_cl;
alter table ${iml_schema}.pty_rela_party_nature_ps_info_h exchange subpartition p_rpssf1_20991231 with table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_rela_party_nature_ps_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_tm purge;
drop table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_op purge;
drop table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_rela_party_nature_ps_info_h_rpssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_rela_party_nature_ps_info_h', partname => 'p_rpssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
