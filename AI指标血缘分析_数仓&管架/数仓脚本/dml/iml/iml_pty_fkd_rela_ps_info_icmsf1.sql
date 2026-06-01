/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_fkd_rela_ps_info_icmsf1
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
alter table ${iml_schema}.pty_fkd_rela_ps_info add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_fkd_rela_ps_info partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_tm purge;
drop table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_op purge;
drop table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    fkd_rela_ps_list_id -- 房快贷关联人列表编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,rela_ps_type_cd -- 关联人类型代码
    ,rela_ps_name -- 关联人姓名
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_cert_no -- 关联人证件号码
    ,and_main_brwer_rela_cd -- 与主借款人关系代码
    ,rela_ps_resdnt_addr_city_cd -- 关联人居住地址城市代码
    ,rela_ps_resdnt_addr -- 关联人居住地址
    ,rela_ps_marriage_situ_cd -- 关联人婚姻状况代码
    ,rela_ps_spouse_name -- 关联人配偶姓名
    ,rela_ps_spouse_mobile_no -- 关联人配偶手机号码
    ,rela_ps_spouse_cert_type_cd -- 关联人配偶证件类型代码
    ,rela_ps_spouse_cert_no -- 关联人配偶证件号码
    ,rela_ps_cert_exp_dt -- 关联人证件到期日
    ,cust_id -- 客户编号
    ,rev_fraud_rest -- 反欺诈结果
    ,crdtc_rest -- 征信结果
    ,cust_char_cd -- 客户性质代码
    ,corp_max_nature_ps_shard_flg -- 企业最大自然人股东标志
    ,farm_flg -- 农户标志
    ,guartor_flg -- 担保人标志
    ,mtg_ps_mtg_have_lot -- 抵押人对抵押物拥有的份额
    ,rel_esat_own_situ -- 不动产共有情况
    ,rela_ps_nationty -- 关联人民族
    ,rela_ps_nation_cd -- 关联人国籍代码
    ,rela_ps_rpr_addr -- 关联人户籍地址
    ,rela_ps_rpr_char -- 关联人户籍性质
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_edu_cd -- 关联人学历代码
    ,brwer_and_group_rela_cd -- 关联人证件起始日期
    ,rela_ps_cert_valid_dt -- 关联人证件有效日期
    ,rela_ps_work_years -- 关联人工作年限
    ,rela_ps_at_mon_inco -- 关联人税后月收入
    ,rela_ps_career_cd -- 关联人职业代码
    ,rela_ps_corp_addr -- 关联人单位地址
    ,rela_ps_corp_char -- 关联人单位性质
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_work_tel -- 关联人单位电话
    ,rela_ps_spouse_career_cd -- 关联人配偶职业代码
    ,rela_ps_spouse_cert_invalid_dt -- 关联人配偶证件失效日期
    ,rela_ps_spouse_gender_cd -- 关联人配偶性别代码
    ,rela_ps_spouse_nation_cd -- 关联人配偶国籍代码
    ,rela_ps_spouse_resdnt_addr -- 关联人配偶居住地址
    ,rela_ps_spouse_rpr_char_cd -- 关联人配偶户籍性质代码
    ,rela_ps_have_house_flg -- 关联人有房标志
    ,final_update_dt -- 最后更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_fkd_rela_ps_info partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_fkd_rela_ps_info partition for ('icmsf1') where 0=1;

create table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_fkd_rela_ps_info partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_fkd_rel_list-
insert into ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_tm(
    fkd_rela_ps_list_id -- 房快贷关联人列表编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,rela_ps_type_cd -- 关联人类型代码
    ,rela_ps_name -- 关联人姓名
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_cert_no -- 关联人证件号码
    ,and_main_brwer_rela_cd -- 与主借款人关系代码
    ,rela_ps_resdnt_addr_city_cd -- 关联人居住地址城市代码
    ,rela_ps_resdnt_addr -- 关联人居住地址
    ,rela_ps_marriage_situ_cd -- 关联人婚姻状况代码
    ,rela_ps_spouse_name -- 关联人配偶姓名
    ,rela_ps_spouse_mobile_no -- 关联人配偶手机号码
    ,rela_ps_spouse_cert_type_cd -- 关联人配偶证件类型代码
    ,rela_ps_spouse_cert_no -- 关联人配偶证件号码
    ,rela_ps_cert_exp_dt -- 关联人证件到期日
    ,cust_id -- 客户编号
    ,rev_fraud_rest -- 反欺诈结果
    ,crdtc_rest -- 征信结果
    ,cust_char_cd -- 客户性质代码
    ,corp_max_nature_ps_shard_flg -- 企业最大自然人股东标志
    ,farm_flg -- 农户标志
    ,guartor_flg -- 担保人标志
    ,mtg_ps_mtg_have_lot -- 抵押人对抵押物拥有的份额
    ,rel_esat_own_situ -- 不动产共有情况
    ,rela_ps_nationty -- 关联人民族
    ,rela_ps_nation_cd -- 关联人国籍代码
    ,rela_ps_rpr_addr -- 关联人户籍地址
    ,rela_ps_rpr_char -- 关联人户籍性质
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_edu_cd -- 关联人学历代码
    ,brwer_and_group_rela_cd -- 关联人证件起始日期
    ,rela_ps_cert_valid_dt -- 关联人证件有效日期
    ,rela_ps_work_years -- 关联人工作年限
    ,rela_ps_at_mon_inco -- 关联人税后月收入
    ,rela_ps_career_cd -- 关联人职业代码
    ,rela_ps_corp_addr -- 关联人单位地址
    ,rela_ps_corp_char -- 关联人单位性质
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_work_tel -- 关联人单位电话
    ,rela_ps_spouse_career_cd -- 关联人配偶职业代码
    ,rela_ps_spouse_cert_invalid_dt -- 关联人配偶证件失效日期
    ,rela_ps_spouse_gender_cd -- 关联人配偶性别代码
    ,rela_ps_spouse_nation_cd -- 关联人配偶国籍代码
    ,rela_ps_spouse_resdnt_addr -- 关联人配偶居住地址
    ,rela_ps_spouse_rpr_char_cd -- 关联人配偶户籍性质代码
    ,rela_ps_have_house_flg -- 关联人有房标志
    ,final_update_dt -- 最后更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SERIALNO -- 房快贷关联人列表编号
    , '9999' -- 法人编号
    ,P1.RELATIVESERIALNO -- 业务流水号
    ,P1.RELTYP -- 关联人类型代码
    ,P1.RELNAME -- 关联人姓名
    ,P1.RELTELNO -- 关联人手机号码
    ,nvl(trim(P1.RELIDTYPE),'0000') -- 关联人证件类型代码
    ,P1.RELIDNO -- 关联人证件号码
    ,P1.RELRELATIONSHIP -- 与主借款人关系代码
    ,NVL(TRIM(P1.RELFAMILYCITYID),'000000') -- 关联人居住地址城市代码
    ,P1.RELFAMILYADDR -- 关联人居住地址
    ,NVL(TRIM(P1.RELMARRIAGE),'90') -- 关联人婚姻状况代码
    ,P1.RELPARTNERNAME -- 关联人配偶姓名
    ,P1.RELPARTNERTELNO -- 关联人配偶手机号码
    ,P1.RELPARTNERIDTYPE -- 关联人配偶证件类型代码
    ,P1.RELPARTNERIDNO -- 关联人配偶证件号码
    ,P1.RELIDEXPIRE -- 关联人证件到期日
    ,P1.CUSID -- 客户编号
    ,P1.FQZRESULT -- 反欺诈结果
    ,P1.ZXRESULT -- 征信结果
    ,nvl(trim(P1.BUSINESSESFLAG),'-') -- 客户性质代码
    ,nvl(trim(P1.ISRELATEMAXENTHOLDER),'-') -- 企业最大自然人股东标志
    ,nvl(trim(P1.AGRIFLG),'-') -- 农户标志
    ,nvl(trim(P1.WTHRGUART),'-') -- 担保人标志
    ,P1.OWNSHARE -- 抵押人对抵押物拥有的份额
    ,P1.IMMOVABLES -- 不动产共有情况
    ,P1.RELETHNIC -- 关联人民族
    ,nvl(trim(P1.RELNATION),'XXX') -- 关联人国籍代码
    ,P1.RELRESIADR -- 关联人户籍地址
    ,P1.NATURECATEGORYREL -- 关联人户籍性质
    ,nvl(trim(P1.RELSEX),'0') -- 关联人性别代码
    ,nvl(trim(P1.EDUEXPERIENCEREL),'00') -- 关联人学历代码
    ,P1.RELATIONSHIP -- 关联人证件起始日期
    ,P1.RELIDEFFECTIVE -- 关联人证件有效日期
    ,P1.RELEMPLMYEARS -- 关联人工作年限
    ,P1.RELTAXAFTERMONINCOME -- 关联人税后月收入
    ,nvl(trim(P1.RELCAREER),'-') -- 关联人职业代码
    ,P1.RELCORPADR -- 关联人单位地址
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.RELCORPPROP END -- 关联人单位性质
    ,P1.RELCORPNAME -- 关联人单位名称
    ,P1.RELCORPTEL -- 关联人单位电话
    ,nvl(trim(P1.RELPARTNERCAREER),'-') -- 关联人配偶职业代码
    ,P1.RELPARTNERIDEXPIRE -- 关联人配偶证件失效日期
    ,nvl(trim(P1.RELPARTNERSEX),'0') -- 关联人配偶性别代码
    ,nvl(trim(P1.RELPARTNERNATION),'XXX') -- 关联人配偶国籍代码
    ,P1.RELPARTNERADDR -- 关联人配偶居住地址
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.NATURECATEGORYRELSPS END -- 关联人配偶户籍性质代码
    ,nvl(trim(P1.RELWTHRHOUSE),'-') -- 关联人有房标志
    ,P1.UPDATEDATE -- 最后更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_fkd_rel_list' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_fkd_rel_list p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.RELCORPPROP = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_FKD_REL_LIST'
        AND R2.SRC_FIELD_EN_NAME= 'RELCORPPROP'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_FKD_RELA_PS_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'RELA_PS_CORP_CHAR'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.NATURECATEGORYRELSPS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_FKD_REL_LIST'
        AND R1.SRC_FIELD_EN_NAME= 'NATURECATEGORYRELSPS'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_FKD_RELA_PS_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'RELA_PS_SPOUSE_RPR_CHAR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_tm 
  	                                group by 
  	                                        fkd_rela_ps_list_id
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
        into ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_cl(
            fkd_rela_ps_list_id -- 房快贷关联人列表编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,rela_ps_type_cd -- 关联人类型代码
    ,rela_ps_name -- 关联人姓名
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_cert_no -- 关联人证件号码
    ,and_main_brwer_rela_cd -- 与主借款人关系代码
    ,rela_ps_resdnt_addr_city_cd -- 关联人居住地址城市代码
    ,rela_ps_resdnt_addr -- 关联人居住地址
    ,rela_ps_marriage_situ_cd -- 关联人婚姻状况代码
    ,rela_ps_spouse_name -- 关联人配偶姓名
    ,rela_ps_spouse_mobile_no -- 关联人配偶手机号码
    ,rela_ps_spouse_cert_type_cd -- 关联人配偶证件类型代码
    ,rela_ps_spouse_cert_no -- 关联人配偶证件号码
    ,rela_ps_cert_exp_dt -- 关联人证件到期日
    ,cust_id -- 客户编号
    ,rev_fraud_rest -- 反欺诈结果
    ,crdtc_rest -- 征信结果
    ,cust_char_cd -- 客户性质代码
    ,corp_max_nature_ps_shard_flg -- 企业最大自然人股东标志
    ,farm_flg -- 农户标志
    ,guartor_flg -- 担保人标志
    ,mtg_ps_mtg_have_lot -- 抵押人对抵押物拥有的份额
    ,rel_esat_own_situ -- 不动产共有情况
    ,rela_ps_nationty -- 关联人民族
    ,rela_ps_nation_cd -- 关联人国籍代码
    ,rela_ps_rpr_addr -- 关联人户籍地址
    ,rela_ps_rpr_char -- 关联人户籍性质
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_edu_cd -- 关联人学历代码
    ,brwer_and_group_rela_cd -- 关联人证件起始日期
    ,rela_ps_cert_valid_dt -- 关联人证件有效日期
    ,rela_ps_work_years -- 关联人工作年限
    ,rela_ps_at_mon_inco -- 关联人税后月收入
    ,rela_ps_career_cd -- 关联人职业代码
    ,rela_ps_corp_addr -- 关联人单位地址
    ,rela_ps_corp_char -- 关联人单位性质
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_work_tel -- 关联人单位电话
    ,rela_ps_spouse_career_cd -- 关联人配偶职业代码
    ,rela_ps_spouse_cert_invalid_dt -- 关联人配偶证件失效日期
    ,rela_ps_spouse_gender_cd -- 关联人配偶性别代码
    ,rela_ps_spouse_nation_cd -- 关联人配偶国籍代码
    ,rela_ps_spouse_resdnt_addr -- 关联人配偶居住地址
    ,rela_ps_spouse_rpr_char_cd -- 关联人配偶户籍性质代码
    ,rela_ps_have_house_flg -- 关联人有房标志
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_op(
            fkd_rela_ps_list_id -- 房快贷关联人列表编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,rela_ps_type_cd -- 关联人类型代码
    ,rela_ps_name -- 关联人姓名
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_cert_no -- 关联人证件号码
    ,and_main_brwer_rela_cd -- 与主借款人关系代码
    ,rela_ps_resdnt_addr_city_cd -- 关联人居住地址城市代码
    ,rela_ps_resdnt_addr -- 关联人居住地址
    ,rela_ps_marriage_situ_cd -- 关联人婚姻状况代码
    ,rela_ps_spouse_name -- 关联人配偶姓名
    ,rela_ps_spouse_mobile_no -- 关联人配偶手机号码
    ,rela_ps_spouse_cert_type_cd -- 关联人配偶证件类型代码
    ,rela_ps_spouse_cert_no -- 关联人配偶证件号码
    ,rela_ps_cert_exp_dt -- 关联人证件到期日
    ,cust_id -- 客户编号
    ,rev_fraud_rest -- 反欺诈结果
    ,crdtc_rest -- 征信结果
    ,cust_char_cd -- 客户性质代码
    ,corp_max_nature_ps_shard_flg -- 企业最大自然人股东标志
    ,farm_flg -- 农户标志
    ,guartor_flg -- 担保人标志
    ,mtg_ps_mtg_have_lot -- 抵押人对抵押物拥有的份额
    ,rel_esat_own_situ -- 不动产共有情况
    ,rela_ps_nationty -- 关联人民族
    ,rela_ps_nation_cd -- 关联人国籍代码
    ,rela_ps_rpr_addr -- 关联人户籍地址
    ,rela_ps_rpr_char -- 关联人户籍性质
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_edu_cd -- 关联人学历代码
    ,brwer_and_group_rela_cd -- 关联人证件起始日期
    ,rela_ps_cert_valid_dt -- 关联人证件有效日期
    ,rela_ps_work_years -- 关联人工作年限
    ,rela_ps_at_mon_inco -- 关联人税后月收入
    ,rela_ps_career_cd -- 关联人职业代码
    ,rela_ps_corp_addr -- 关联人单位地址
    ,rela_ps_corp_char -- 关联人单位性质
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_work_tel -- 关联人单位电话
    ,rela_ps_spouse_career_cd -- 关联人配偶职业代码
    ,rela_ps_spouse_cert_invalid_dt -- 关联人配偶证件失效日期
    ,rela_ps_spouse_gender_cd -- 关联人配偶性别代码
    ,rela_ps_spouse_nation_cd -- 关联人配偶国籍代码
    ,rela_ps_spouse_resdnt_addr -- 关联人配偶居住地址
    ,rela_ps_spouse_rpr_char_cd -- 关联人配偶户籍性质代码
    ,rela_ps_have_house_flg -- 关联人有房标志
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fkd_rela_ps_list_id, o.fkd_rela_ps_list_id) as fkd_rela_ps_list_id -- 房快贷关联人列表编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.bus_flow_num, o.bus_flow_num) as bus_flow_num -- 业务流水号
    ,nvl(n.rela_ps_type_cd, o.rela_ps_type_cd) as rela_ps_type_cd -- 关联人类型代码
    ,nvl(n.rela_ps_name, o.rela_ps_name) as rela_ps_name -- 关联人姓名
    ,nvl(n.rela_ps_mobile_no, o.rela_ps_mobile_no) as rela_ps_mobile_no -- 关联人手机号码
    ,nvl(n.rela_ps_cert_type_cd, o.rela_ps_cert_type_cd) as rela_ps_cert_type_cd -- 关联人证件类型代码
    ,nvl(n.rela_ps_cert_no, o.rela_ps_cert_no) as rela_ps_cert_no -- 关联人证件号码
    ,nvl(n.and_main_brwer_rela_cd, o.and_main_brwer_rela_cd) as and_main_brwer_rela_cd -- 与主借款人关系代码
    ,nvl(n.rela_ps_resdnt_addr_city_cd, o.rela_ps_resdnt_addr_city_cd) as rela_ps_resdnt_addr_city_cd -- 关联人居住地址城市代码
    ,nvl(n.rela_ps_resdnt_addr, o.rela_ps_resdnt_addr) as rela_ps_resdnt_addr -- 关联人居住地址
    ,nvl(n.rela_ps_marriage_situ_cd, o.rela_ps_marriage_situ_cd) as rela_ps_marriage_situ_cd -- 关联人婚姻状况代码
    ,nvl(n.rela_ps_spouse_name, o.rela_ps_spouse_name) as rela_ps_spouse_name -- 关联人配偶姓名
    ,nvl(n.rela_ps_spouse_mobile_no, o.rela_ps_spouse_mobile_no) as rela_ps_spouse_mobile_no -- 关联人配偶手机号码
    ,nvl(n.rela_ps_spouse_cert_type_cd, o.rela_ps_spouse_cert_type_cd) as rela_ps_spouse_cert_type_cd -- 关联人配偶证件类型代码
    ,nvl(n.rela_ps_spouse_cert_no, o.rela_ps_spouse_cert_no) as rela_ps_spouse_cert_no -- 关联人配偶证件号码
    ,nvl(n.rela_ps_cert_exp_dt, o.rela_ps_cert_exp_dt) as rela_ps_cert_exp_dt -- 关联人证件到期日
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.rev_fraud_rest, o.rev_fraud_rest) as rev_fraud_rest -- 反欺诈结果
    ,nvl(n.crdtc_rest, o.crdtc_rest) as crdtc_rest -- 征信结果
    ,nvl(n.cust_char_cd, o.cust_char_cd) as cust_char_cd -- 客户性质代码
    ,nvl(n.corp_max_nature_ps_shard_flg, o.corp_max_nature_ps_shard_flg) as corp_max_nature_ps_shard_flg -- 企业最大自然人股东标志
    ,nvl(n.farm_flg, o.farm_flg) as farm_flg -- 农户标志
    ,nvl(n.guartor_flg, o.guartor_flg) as guartor_flg -- 担保人标志
    ,nvl(n.mtg_ps_mtg_have_lot, o.mtg_ps_mtg_have_lot) as mtg_ps_mtg_have_lot -- 抵押人对抵押物拥有的份额
    ,nvl(n.rel_esat_own_situ, o.rel_esat_own_situ) as rel_esat_own_situ -- 不动产共有情况
    ,nvl(n.rela_ps_nationty, o.rela_ps_nationty) as rela_ps_nationty -- 关联人民族
    ,nvl(n.rela_ps_nation_cd, o.rela_ps_nation_cd) as rela_ps_nation_cd -- 关联人国籍代码
    ,nvl(n.rela_ps_rpr_addr, o.rela_ps_rpr_addr) as rela_ps_rpr_addr -- 关联人户籍地址
    ,nvl(n.rela_ps_rpr_char, o.rela_ps_rpr_char) as rela_ps_rpr_char -- 关联人户籍性质
    ,nvl(n.rela_ps_gender_cd, o.rela_ps_gender_cd) as rela_ps_gender_cd -- 关联人性别代码
    ,nvl(n.rela_ps_edu_cd, o.rela_ps_edu_cd) as rela_ps_edu_cd -- 关联人学历代码
    ,nvl(n.brwer_and_group_rela_cd, o.brwer_and_group_rela_cd) as brwer_and_group_rela_cd -- 关联人证件起始日期
    ,nvl(n.rela_ps_cert_valid_dt, o.rela_ps_cert_valid_dt) as rela_ps_cert_valid_dt -- 关联人证件有效日期
    ,nvl(n.rela_ps_work_years, o.rela_ps_work_years) as rela_ps_work_years -- 关联人工作年限
    ,nvl(n.rela_ps_at_mon_inco, o.rela_ps_at_mon_inco) as rela_ps_at_mon_inco -- 关联人税后月收入
    ,nvl(n.rela_ps_career_cd, o.rela_ps_career_cd) as rela_ps_career_cd -- 关联人职业代码
    ,nvl(n.rela_ps_corp_addr, o.rela_ps_corp_addr) as rela_ps_corp_addr -- 关联人单位地址
    ,nvl(n.rela_ps_corp_char, o.rela_ps_corp_char) as rela_ps_corp_char -- 关联人单位性质
    ,nvl(n.rela_ps_corp_name, o.rela_ps_corp_name) as rela_ps_corp_name -- 关联人单位名称
    ,nvl(n.rela_ps_work_tel, o.rela_ps_work_tel) as rela_ps_work_tel -- 关联人单位电话
    ,nvl(n.rela_ps_spouse_career_cd, o.rela_ps_spouse_career_cd) as rela_ps_spouse_career_cd -- 关联人配偶职业代码
    ,nvl(n.rela_ps_spouse_cert_invalid_dt, o.rela_ps_spouse_cert_invalid_dt) as rela_ps_spouse_cert_invalid_dt -- 关联人配偶证件失效日期
    ,nvl(n.rela_ps_spouse_gender_cd, o.rela_ps_spouse_gender_cd) as rela_ps_spouse_gender_cd -- 关联人配偶性别代码
    ,nvl(n.rela_ps_spouse_nation_cd, o.rela_ps_spouse_nation_cd) as rela_ps_spouse_nation_cd -- 关联人配偶国籍代码
    ,nvl(n.rela_ps_spouse_resdnt_addr, o.rela_ps_spouse_resdnt_addr) as rela_ps_spouse_resdnt_addr -- 关联人配偶居住地址
    ,nvl(n.rela_ps_spouse_rpr_char_cd, o.rela_ps_spouse_rpr_char_cd) as rela_ps_spouse_rpr_char_cd -- 关联人配偶户籍性质代码
    ,nvl(n.rela_ps_have_house_flg, o.rela_ps_have_house_flg) as rela_ps_have_house_flg -- 关联人有房标志
    ,nvl(n.final_update_dt, o.final_update_dt) as final_update_dt -- 最后更新日期
    ,case when
            n.fkd_rela_ps_list_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fkd_rela_ps_list_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fkd_rela_ps_list_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_tm n
    full join (select * from ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.fkd_rela_ps_list_id = n.fkd_rela_ps_list_id
            and o.lp_id = n.lp_id
where (
        o.fkd_rela_ps_list_id is null
        and o.lp_id is null
    )
    or (
        n.fkd_rela_ps_list_id is null
        and n.lp_id is null
    )
    or (
        o.bus_flow_num <> n.bus_flow_num
        or o.rela_ps_type_cd <> n.rela_ps_type_cd
        or o.rela_ps_name <> n.rela_ps_name
        or o.rela_ps_mobile_no <> n.rela_ps_mobile_no
        or o.rela_ps_cert_type_cd <> n.rela_ps_cert_type_cd
        or o.rela_ps_cert_no <> n.rela_ps_cert_no
        or o.and_main_brwer_rela_cd <> n.and_main_brwer_rela_cd
        or o.rela_ps_resdnt_addr_city_cd <> n.rela_ps_resdnt_addr_city_cd
        or o.rela_ps_resdnt_addr <> n.rela_ps_resdnt_addr
        or o.rela_ps_marriage_situ_cd <> n.rela_ps_marriage_situ_cd
        or o.rela_ps_spouse_name <> n.rela_ps_spouse_name
        or o.rela_ps_spouse_mobile_no <> n.rela_ps_spouse_mobile_no
        or o.rela_ps_spouse_cert_type_cd <> n.rela_ps_spouse_cert_type_cd
        or o.rela_ps_spouse_cert_no <> n.rela_ps_spouse_cert_no
        or o.rela_ps_cert_exp_dt <> n.rela_ps_cert_exp_dt
        or o.cust_id <> n.cust_id
        or o.rev_fraud_rest <> n.rev_fraud_rest
        or o.crdtc_rest <> n.crdtc_rest
        or o.cust_char_cd <> n.cust_char_cd
        or o.corp_max_nature_ps_shard_flg <> n.corp_max_nature_ps_shard_flg
        or o.farm_flg <> n.farm_flg
        or o.guartor_flg <> n.guartor_flg
        or o.mtg_ps_mtg_have_lot <> n.mtg_ps_mtg_have_lot
        or o.rel_esat_own_situ <> n.rel_esat_own_situ
        or o.rela_ps_nationty <> n.rela_ps_nationty
        or o.rela_ps_nation_cd <> n.rela_ps_nation_cd
        or o.rela_ps_rpr_addr <> n.rela_ps_rpr_addr
        or o.rela_ps_rpr_char <> n.rela_ps_rpr_char
        or o.rela_ps_gender_cd <> n.rela_ps_gender_cd
        or o.rela_ps_edu_cd <> n.rela_ps_edu_cd
        or o.brwer_and_group_rela_cd <> n.brwer_and_group_rela_cd
        or o.rela_ps_cert_valid_dt <> n.rela_ps_cert_valid_dt
        or o.rela_ps_work_years <> n.rela_ps_work_years
        or o.rela_ps_at_mon_inco <> n.rela_ps_at_mon_inco
        or o.rela_ps_career_cd <> n.rela_ps_career_cd
        or o.rela_ps_corp_addr <> n.rela_ps_corp_addr
        or o.rela_ps_corp_char <> n.rela_ps_corp_char
        or o.rela_ps_corp_name <> n.rela_ps_corp_name
        or o.rela_ps_work_tel <> n.rela_ps_work_tel
        or o.rela_ps_spouse_career_cd <> n.rela_ps_spouse_career_cd
        or o.rela_ps_spouse_cert_invalid_dt <> n.rela_ps_spouse_cert_invalid_dt
        or o.rela_ps_spouse_gender_cd <> n.rela_ps_spouse_gender_cd
        or o.rela_ps_spouse_nation_cd <> n.rela_ps_spouse_nation_cd
        or o.rela_ps_spouse_resdnt_addr <> n.rela_ps_spouse_resdnt_addr
        or o.rela_ps_spouse_rpr_char_cd <> n.rela_ps_spouse_rpr_char_cd
        or o.rela_ps_have_house_flg <> n.rela_ps_have_house_flg
        or o.final_update_dt <> n.final_update_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_cl(
            fkd_rela_ps_list_id -- 房快贷关联人列表编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,rela_ps_type_cd -- 关联人类型代码
    ,rela_ps_name -- 关联人姓名
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_cert_no -- 关联人证件号码
    ,and_main_brwer_rela_cd -- 与主借款人关系代码
    ,rela_ps_resdnt_addr_city_cd -- 关联人居住地址城市代码
    ,rela_ps_resdnt_addr -- 关联人居住地址
    ,rela_ps_marriage_situ_cd -- 关联人婚姻状况代码
    ,rela_ps_spouse_name -- 关联人配偶姓名
    ,rela_ps_spouse_mobile_no -- 关联人配偶手机号码
    ,rela_ps_spouse_cert_type_cd -- 关联人配偶证件类型代码
    ,rela_ps_spouse_cert_no -- 关联人配偶证件号码
    ,rela_ps_cert_exp_dt -- 关联人证件到期日
    ,cust_id -- 客户编号
    ,rev_fraud_rest -- 反欺诈结果
    ,crdtc_rest -- 征信结果
    ,cust_char_cd -- 客户性质代码
    ,corp_max_nature_ps_shard_flg -- 企业最大自然人股东标志
    ,farm_flg -- 农户标志
    ,guartor_flg -- 担保人标志
    ,mtg_ps_mtg_have_lot -- 抵押人对抵押物拥有的份额
    ,rel_esat_own_situ -- 不动产共有情况
    ,rela_ps_nationty -- 关联人民族
    ,rela_ps_nation_cd -- 关联人国籍代码
    ,rela_ps_rpr_addr -- 关联人户籍地址
    ,rela_ps_rpr_char -- 关联人户籍性质
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_edu_cd -- 关联人学历代码
    ,brwer_and_group_rela_cd -- 关联人证件起始日期
    ,rela_ps_cert_valid_dt -- 关联人证件有效日期
    ,rela_ps_work_years -- 关联人工作年限
    ,rela_ps_at_mon_inco -- 关联人税后月收入
    ,rela_ps_career_cd -- 关联人职业代码
    ,rela_ps_corp_addr -- 关联人单位地址
    ,rela_ps_corp_char -- 关联人单位性质
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_work_tel -- 关联人单位电话
    ,rela_ps_spouse_career_cd -- 关联人配偶职业代码
    ,rela_ps_spouse_cert_invalid_dt -- 关联人配偶证件失效日期
    ,rela_ps_spouse_gender_cd -- 关联人配偶性别代码
    ,rela_ps_spouse_nation_cd -- 关联人配偶国籍代码
    ,rela_ps_spouse_resdnt_addr -- 关联人配偶居住地址
    ,rela_ps_spouse_rpr_char_cd -- 关联人配偶户籍性质代码
    ,rela_ps_have_house_flg -- 关联人有房标志
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_op(
            fkd_rela_ps_list_id -- 房快贷关联人列表编号
    ,lp_id -- 法人编号
    ,bus_flow_num -- 业务流水号
    ,rela_ps_type_cd -- 关联人类型代码
    ,rela_ps_name -- 关联人姓名
    ,rela_ps_mobile_no -- 关联人手机号码
    ,rela_ps_cert_type_cd -- 关联人证件类型代码
    ,rela_ps_cert_no -- 关联人证件号码
    ,and_main_brwer_rela_cd -- 与主借款人关系代码
    ,rela_ps_resdnt_addr_city_cd -- 关联人居住地址城市代码
    ,rela_ps_resdnt_addr -- 关联人居住地址
    ,rela_ps_marriage_situ_cd -- 关联人婚姻状况代码
    ,rela_ps_spouse_name -- 关联人配偶姓名
    ,rela_ps_spouse_mobile_no -- 关联人配偶手机号码
    ,rela_ps_spouse_cert_type_cd -- 关联人配偶证件类型代码
    ,rela_ps_spouse_cert_no -- 关联人配偶证件号码
    ,rela_ps_cert_exp_dt -- 关联人证件到期日
    ,cust_id -- 客户编号
    ,rev_fraud_rest -- 反欺诈结果
    ,crdtc_rest -- 征信结果
    ,cust_char_cd -- 客户性质代码
    ,corp_max_nature_ps_shard_flg -- 企业最大自然人股东标志
    ,farm_flg -- 农户标志
    ,guartor_flg -- 担保人标志
    ,mtg_ps_mtg_have_lot -- 抵押人对抵押物拥有的份额
    ,rel_esat_own_situ -- 不动产共有情况
    ,rela_ps_nationty -- 关联人民族
    ,rela_ps_nation_cd -- 关联人国籍代码
    ,rela_ps_rpr_addr -- 关联人户籍地址
    ,rela_ps_rpr_char -- 关联人户籍性质
    ,rela_ps_gender_cd -- 关联人性别代码
    ,rela_ps_edu_cd -- 关联人学历代码
    ,brwer_and_group_rela_cd -- 关联人证件起始日期
    ,rela_ps_cert_valid_dt -- 关联人证件有效日期
    ,rela_ps_work_years -- 关联人工作年限
    ,rela_ps_at_mon_inco -- 关联人税后月收入
    ,rela_ps_career_cd -- 关联人职业代码
    ,rela_ps_corp_addr -- 关联人单位地址
    ,rela_ps_corp_char -- 关联人单位性质
    ,rela_ps_corp_name -- 关联人单位名称
    ,rela_ps_work_tel -- 关联人单位电话
    ,rela_ps_spouse_career_cd -- 关联人配偶职业代码
    ,rela_ps_spouse_cert_invalid_dt -- 关联人配偶证件失效日期
    ,rela_ps_spouse_gender_cd -- 关联人配偶性别代码
    ,rela_ps_spouse_nation_cd -- 关联人配偶国籍代码
    ,rela_ps_spouse_resdnt_addr -- 关联人配偶居住地址
    ,rela_ps_spouse_rpr_char_cd -- 关联人配偶户籍性质代码
    ,rela_ps_have_house_flg -- 关联人有房标志
    ,final_update_dt -- 最后更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fkd_rela_ps_list_id -- 房快贷关联人列表编号
    ,o.lp_id -- 法人编号
    ,o.bus_flow_num -- 业务流水号
    ,o.rela_ps_type_cd -- 关联人类型代码
    ,o.rela_ps_name -- 关联人姓名
    ,o.rela_ps_mobile_no -- 关联人手机号码
    ,o.rela_ps_cert_type_cd -- 关联人证件类型代码
    ,o.rela_ps_cert_no -- 关联人证件号码
    ,o.and_main_brwer_rela_cd -- 与主借款人关系代码
    ,o.rela_ps_resdnt_addr_city_cd -- 关联人居住地址城市代码
    ,o.rela_ps_resdnt_addr -- 关联人居住地址
    ,o.rela_ps_marriage_situ_cd -- 关联人婚姻状况代码
    ,o.rela_ps_spouse_name -- 关联人配偶姓名
    ,o.rela_ps_spouse_mobile_no -- 关联人配偶手机号码
    ,o.rela_ps_spouse_cert_type_cd -- 关联人配偶证件类型代码
    ,o.rela_ps_spouse_cert_no -- 关联人配偶证件号码
    ,o.rela_ps_cert_exp_dt -- 关联人证件到期日
    ,o.cust_id -- 客户编号
    ,o.rev_fraud_rest -- 反欺诈结果
    ,o.crdtc_rest -- 征信结果
    ,o.cust_char_cd -- 客户性质代码
    ,o.corp_max_nature_ps_shard_flg -- 企业最大自然人股东标志
    ,o.farm_flg -- 农户标志
    ,o.guartor_flg -- 担保人标志
    ,o.mtg_ps_mtg_have_lot -- 抵押人对抵押物拥有的份额
    ,o.rel_esat_own_situ -- 不动产共有情况
    ,o.rela_ps_nationty -- 关联人民族
    ,o.rela_ps_nation_cd -- 关联人国籍代码
    ,o.rela_ps_rpr_addr -- 关联人户籍地址
    ,o.rela_ps_rpr_char -- 关联人户籍性质
    ,o.rela_ps_gender_cd -- 关联人性别代码
    ,o.rela_ps_edu_cd -- 关联人学历代码
    ,o.brwer_and_group_rela_cd -- 关联人证件起始日期
    ,o.rela_ps_cert_valid_dt -- 关联人证件有效日期
    ,o.rela_ps_work_years -- 关联人工作年限
    ,o.rela_ps_at_mon_inco -- 关联人税后月收入
    ,o.rela_ps_career_cd -- 关联人职业代码
    ,o.rela_ps_corp_addr -- 关联人单位地址
    ,o.rela_ps_corp_char -- 关联人单位性质
    ,o.rela_ps_corp_name -- 关联人单位名称
    ,o.rela_ps_work_tel -- 关联人单位电话
    ,o.rela_ps_spouse_career_cd -- 关联人配偶职业代码
    ,o.rela_ps_spouse_cert_invalid_dt -- 关联人配偶证件失效日期
    ,o.rela_ps_spouse_gender_cd -- 关联人配偶性别代码
    ,o.rela_ps_spouse_nation_cd -- 关联人配偶国籍代码
    ,o.rela_ps_spouse_resdnt_addr -- 关联人配偶居住地址
    ,o.rela_ps_spouse_rpr_char_cd -- 关联人配偶户籍性质代码
    ,o.rela_ps_have_house_flg -- 关联人有房标志
    ,o.final_update_dt -- 最后更新日期
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
from ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_bk o
    left join ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_op n
        on
            o.fkd_rela_ps_list_id = n.fkd_rela_ps_list_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_cl d
        on
            o.fkd_rela_ps_list_id = d.fkd_rela_ps_list_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_fkd_rela_ps_info;
--alter table ${iml_schema}.pty_fkd_rela_ps_info truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('pty_fkd_rela_ps_info') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.pty_fkd_rela_ps_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_fkd_rela_ps_info modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.pty_fkd_rela_ps_info exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_cl;
alter table ${iml_schema}.pty_fkd_rela_ps_info exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_fkd_rela_ps_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_tm purge;
drop table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_op purge;
drop table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_fkd_rela_ps_info_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_fkd_rela_ps_info', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
