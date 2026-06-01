/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_indv_eifsf1
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
alter table ${iml_schema}.pty_indv add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_eifsf1_20991231 values less than (maxvalue)
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_indv_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv partition for ('eifsf1')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.pty_indv_eifsf1_tm purge;
drop table ${iml_schema}.pty_indv_eifsf1_op purge;
drop table ${iml_schema}.pty_indv_eifsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_indv_eifsf1_tm nologging
compress ${option_switch} for query high
as select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状态代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 员工标志
    ,dist_cd -- 行政区域代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 取得税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 主体类型代码
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv partition for ('eifsf1')
where 0=1
;

create table ${iml_schema}.pty_indv_eifsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv partition for ('eifsf1') where 0=1;

create table ${iml_schema}.pty_indv_eifsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_indv partition for ('eifsf1') where 0=1;

-- 3.1 get new data into table
-- eifs_person-
insert into ${iml_schema}.pty_indv_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状态代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 员工标志
    ,dist_cd -- 行政区域代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 取得税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 主体类型代码
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    p1.PARTY_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,p1.ENGLISH_NAME -- 个人英文名称
    ,${iml_schema}.dateformat_min(to_char(p1.BIRTH_DATE)) -- 出生日期
    ,' ' -- 出生地址
    ,NVL(TRIM(p1.DEPOSITOR_TYPE),'00') -- 存款人类别代码
    ,NVL(trim(p1.LAST_NAME||p1.MIDDLE_NAME||p1.FIRST_NAME),p1.SALUTATION) -- 当事人名称
    ,p1.WHETHER_INDIVIDUAL_MERCHANT -- 个体工商户标志
    ,p1.INDIVIDUAL_BUSINESS_LICENSE -- 个体工商户证件号码
    ,NVL(TRIM(p1.NATION),'XXX') -- 国籍代码
    ,NVL(TRIM(p1.MARITAL_STATUS),'90') -- 婚姻状况代码
    ,p1.NATIVE_PLACE -- 籍贯代码
    ,NVL(TRIM(p1.RESIDENCE_STATUS_ENUM_ID),'9') -- 居住状态代码
    ,CASE WHEN p1.COUNTRY='99' THEN '97' 
     WHEN TRIM(p1.COUNTRY) is null THEN '97' 
ELSE p1.COUNTRY END -- 民族代码
    ,p1.TAX_NUMBER -- 纳税人识别号
    ,p1.REAL_NAME_MARK -- 实名标志
    ,substr(NVL(TRIM(p1.TAX_AREA),'XXX'),1,20) -- 税收居民国家代码
    ,NVL(TRIM(p1.TAX_RESIDENT),'5') -- 税收居民身份类型代码
    ,p1.WHETHER_SMALL_MICRO_ENT -- 小微企业主标志
    ,p1.SMALL_MICRO_ENT_LICENSE -- 小微企业主证件号码
    ,NVL(TRIM(p1.SMALL_MICRO_ENT_TYPE),'0000') -- 小微企业主证件类型代码
    ,NVL(TRIM(p1.GENDER),'0') -- 性别代码
    ,NVL(trim(p1.LAST_NAME||p1.MIDDLE_NAME||p1.FIRST_NAME),p1.SALUTATION) -- 姓名
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL 
     ELSE '@'||p1.DEGREE
END -- 学位代码
    ,NVL(TRIM(p1.BLOOD_TYPE),'0') -- 血型代码
    ,NVL(p2.YES_NO_CONTRACT,' ') -- 农村承包经营户标志
    ,NVL(p4.attr_value,DECODE(TRIM(P7.ISCOUNTRYHOUSEHOLD),NULL,'-','2','0',P7.ISCOUNTRYHOUSEHOLD)) -- 农户标志
    ,NVL(p03.WKEXIS,'0') -- 有工作单位标志
    ,NVL(TRIM(p3.DUTY),'9') -- 职务代码
    ,NVL(TRIM(p3.TITLE),'9') -- 职称代码
    ,' ' -- 居民性质代码
    ,substr(NVL(TRIM(p03.RGSTAD),'999999'),1,10) -- 地区代码
    ,NVL(trim(p6.attr_value),'-') -- 员工标志
    ,'000000' -- 行政区域代码
    ,NVL(p5.attr_value,'-') -- 居民标志
    ,p1.NATIVE_PLACE -- 籍贯
    ,MONTHS_BETWEEN(to_date('${batch_date}','yyyymmdd'),${iml_schema}.dateformat_min(to_char(p1.BIRTH_DATE)))/12 -- 年龄
    ,' ' -- 业主类型代码
    ,NVL(TRIM(p03.PLVSCD),'-') -- 政治面貌代码
    ,NVL(p03.RELATG,'0') -- 本行关系人标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL 
     WHEN TRIM(p03.HEALTH) IS NULL THEN '-'
     ELSE '@'||p03.HEALTH
END -- 健康状况代码
    ,NVL(p03.ORALLA,' ') -- 口语
    ,NVL(p03.ISINCU,'0') -- 系统内客户标志
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL 
     WHEN TRIM(p03.CUSTLV) IS NULL THEN '0'
     ELSE '@'||p03.CUSTLV
END -- 客户级别代码
    ,p1.TAX_STATEMENT -- 取得税收居民取得自证声明标志
    ,CASE WHEN p02.Party_Type_Id = 'PRIVATE_TYPE' THEN '11'
     WHEN p02.Party_Type_Id = 'GUARANTEE_PRI_TYPE' THEN '17'
ELSE '99'
END -- 个人当事人类型代码
    ,NVL(TRIM(p2.BANK_DUTY),'9') -- 在我行职务类型代码
    ,NVL(p03.SCHOOL,' ') -- 毕业院校
    ,NVL(p03.ISCRED,'-') -- 授信客户标志
    ,CASE  WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@' ||NVL(TRIM(p03.SJCATE),' ') END  -- 主体类型代码
    ,NVL(TRIM(P1.TAX_NULL_REASON),' ') -- 纳税人识别号空值原因描述
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_person' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_person p1
    left join ${iol_schema}.eifs_party p02 on p1.party_id=p02.party_id 
and p02.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p02.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_customer_supplement_info p03 on p03.CUSTNO=p1.party_id 
and p03.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p03.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.crss_ind_info p7 on p7.mfcustomerid=p1.party_id 
and p7.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p7.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r2 on p1.DEGREE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'EIFS'
        AND R2.SRC_TAB_EN_NAME= 'EIFS_PERSON'
        AND R2.SRC_FIELD_EN_NAME= 'DEGREE'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_INDV'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'DEGREE_CD'
    left join (select t1.*,row_number() over(partition by cus_id order by t1.last_upd_date desc) as rid
from ${iol_schema}.rcrs_cus_indiv t1 
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t1.end_dt > to_date('${batch_date}','yyyymmdd')) p2 on p2.CUS_ID=p1.PARTY_ID 
and p2.rid=1
    left join ${iol_schema}.eifs_party_attribute p4 on p1.PARTY_ID = p4.PARTY_ID and  p4.ATTR_NAME='farmeFlag' and p4.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND p4.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join (select t001.*,row_number() over(partition by party_id order by resumeid desc) as rid
from ${iol_schema}.eifs_new_party_resume t001 
where t001.start_dt <= to_date('${batch_date}','yyyymmdd') 
and t001.end_dt > to_date('${batch_date}','yyyymmdd') )  p3 on p1.party_id=p3.party_id and p3.rid = 1
    left join ${iol_schema}.eifs_party_attribute p6 on p1.PARTY_ID = p6.PARTY_ID and  p6.ATTR_NAME='whetherBankStaff' and p6.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND p6.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iol_schema}.eifs_party_attribute p5 on p1.PARTY_ID = p5.PARTY_ID and  p5.ATTR_NAME='whetherFarmer' and p5.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND p5.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
    left join ${iml_schema}.ref_pub_cd_map r3 on NVL(p03.HEALTH,' ') = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'EIFS'
        AND R3.SRC_TAB_EN_NAME= 'EIFS_CUSTOMER_SUPPLEMENT_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'HEALTH'
        AND R3.TARGET_TAB_EN_NAME= 'PTY_INDV'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'HEALTH_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on NVL(p03.CUSTLV,' ') = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'EIFS'
        AND R4.SRC_TAB_EN_NAME= 'EIFS_CUSTOMER_SUPPLEMENT_INFO'
        AND R4.SRC_FIELD_EN_NAME= 'CUSTLV'
        AND R4.TARGET_TAB_EN_NAME= 'PTY_INDV'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CUST_LEV_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on NVL(TRIM(p03.SJCATE),' ') = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'EIFS'
        AND R5.SRC_TAB_EN_NAME= 'EIFS_CUSTOMER_SUPPLEMENT_INFO'
        AND R5.SRC_FIELD_EN_NAME= 'SJCATE'
        AND R5.TARGET_TAB_EN_NAME= 'PTY_INDV'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'MAIN_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_indv_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状态代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 员工标志
    ,dist_cd -- 行政区域代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 取得税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 主体类型代码
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_indv_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状态代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 员工标志
    ,dist_cd -- 行政区域代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 取得税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 主体类型代码
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.indv_en_name, o.indv_en_name) as indv_en_name -- 个人英文名称
    ,nvl(n.birth_dt, o.birth_dt) as birth_dt -- 出生日期
    ,nvl(n.birth_addr, o.birth_addr) as birth_addr -- 出生地址
    ,nvl(n.depositr_cate_cd, o.depositr_cate_cd) as depositr_cate_cd -- 存款人类别代码
    ,nvl(n.party_name, o.party_name) as party_name -- 当事人名称
    ,nvl(n.indv_bus_flg, o.indv_bus_flg) as indv_bus_flg -- 个体工商户标志
    ,nvl(n.indv_bus_cert_no, o.indv_bus_cert_no) as indv_bus_cert_no -- 个体工商户证件号码
    ,nvl(n.nation_cd, o.nation_cd) as nation_cd -- 国籍代码
    ,nvl(n.marriage_situ_cd, o.marriage_situ_cd) as marriage_situ_cd -- 婚姻状况代码
    ,nvl(n.nati_place_cd, o.nati_place_cd) as nati_place_cd -- 籍贯代码
    ,nvl(n.resd_status_cd, o.resd_status_cd) as resd_status_cd -- 居住状态代码
    ,nvl(n.nationty_cd, o.nationty_cd) as nationty_cd -- 民族代码
    ,nvl(n.taxpayer_idtfy_num, o.taxpayer_idtfy_num) as taxpayer_idtfy_num -- 纳税人识别号
    ,nvl(n.real_name_flg, o.real_name_flg) as real_name_flg -- 实名标志
    ,nvl(n.tax_resdnt_cty_cd, o.tax_resdnt_cty_cd) as tax_resdnt_cty_cd -- 税收居民国家代码
    ,nvl(n.tax_resdnt_idti_type_cd, o.tax_resdnt_idti_type_cd) as tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,nvl(n.sm_bus_owner_flg, o.sm_bus_owner_flg) as sm_bus_owner_flg -- 小微企业主标志
    ,nvl(n.sm_bus_owner_cert_no, o.sm_bus_owner_cert_no) as sm_bus_owner_cert_no -- 小微企业主证件号码
    ,nvl(n.sm_bus_owner_cert_type_cd, o.sm_bus_owner_cert_type_cd) as sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,nvl(n.gender_cd, o.gender_cd) as gender_cd -- 性别代码
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.degree_cd, o.degree_cd) as degree_cd -- 学位代码
    ,nvl(n.blood_type_cd, o.blood_type_cd) as blood_type_cd -- 血型代码
    ,nvl(n.ctysd_contr_oper_acct_flg, o.ctysd_contr_oper_acct_flg) as ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,nvl(n.farm_flg, o.farm_flg) as farm_flg -- 农户标志
    ,nvl(n.have_work_unit_flg, o.have_work_unit_flg) as have_work_unit_flg -- 有工作单位标志
    ,nvl(n.post_cd, o.post_cd) as post_cd -- 职务代码
    ,nvl(n.title_cd, o.title_cd) as title_cd -- 职称代码
    ,nvl(n.resdnt_char_cd, o.resdnt_char_cd) as resdnt_char_cd -- 居民性质代码
    ,nvl(n.rg_cd, o.rg_cd) as rg_cd -- 地区代码
    ,nvl(n.emply_flg, o.emply_flg) as emply_flg -- 员工标志
    ,nvl(n.dist_cd, o.dist_cd) as dist_cd -- 行政区域代码
    ,nvl(n.resdnt_flg, o.resdnt_flg) as resdnt_flg -- 居民标志
    ,nvl(n.nati_place, o.nati_place) as nati_place -- 籍贯
    ,nvl(n.age, o.age) as age -- 年龄
    ,nvl(n.owner_type_cd, o.owner_type_cd) as owner_type_cd -- 业主类型代码
    ,nvl(n.politic_status_cd, o.politic_status_cd) as politic_status_cd -- 政治面貌代码
    ,nvl(n.ghb_rela_peop_flg, o.ghb_rela_peop_flg) as ghb_rela_peop_flg -- 本行关系人标志
    ,nvl(n.health_status_cd, o.health_status_cd) as health_status_cd -- 健康状况代码
    ,nvl(n.spoken, o.spoken) as spoken -- 口语
    ,nvl(n.sys_in_cust_flg, o.sys_in_cust_flg) as sys_in_cust_flg -- 系统内客户标志
    ,nvl(n.cust_lev_cd, o.cust_lev_cd) as cust_lev_cd -- 客户级别代码
    ,nvl(n.tax_stament_flg, o.tax_stament_flg) as tax_stament_flg -- 取得税收居民取得自证声明标志
    ,nvl(n.indv_party_type_cd, o.indv_party_type_cd) as indv_party_type_cd -- 个人当事人类型代码
    ,nvl(n.hxb_post_type_cd, o.hxb_post_type_cd) as hxb_post_type_cd -- 在我行职务类型代码
    ,nvl(n.grad_school, o.grad_school) as grad_school -- 毕业院校
    ,nvl(n.crdt_cust_flg, o.crdt_cust_flg) as crdt_cust_flg -- 授信客户标志
    ,nvl(n.main_type_cd, o.main_type_cd) as main_type_cd -- 主体类型代码
    ,nvl(n.tax_num_null_rs_descb, o.tax_num_null_rs_descb) as tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,case when
            n.party_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.party_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_eifsf1_tm n
    full join (select * from ${iml_schema}.pty_indv_eifsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
where (
        o.party_id is null
        and o.lp_id is null
    )
    or (
        n.party_id is null
        and n.lp_id is null
    )
    or (
        o.indv_en_name <> n.indv_en_name
        or o.birth_dt <> n.birth_dt
        or o.birth_addr <> n.birth_addr
        or o.depositr_cate_cd <> n.depositr_cate_cd
        or o.party_name <> n.party_name
        or o.indv_bus_flg <> n.indv_bus_flg
        or o.indv_bus_cert_no <> n.indv_bus_cert_no
        or o.nation_cd <> n.nation_cd
        or o.marriage_situ_cd <> n.marriage_situ_cd
        or o.nati_place_cd <> n.nati_place_cd
        or o.resd_status_cd <> n.resd_status_cd
        or o.nationty_cd <> n.nationty_cd
        or o.taxpayer_idtfy_num <> n.taxpayer_idtfy_num
        or o.real_name_flg <> n.real_name_flg
        or o.tax_resdnt_cty_cd <> n.tax_resdnt_cty_cd
        or o.tax_resdnt_idti_type_cd <> n.tax_resdnt_idti_type_cd
        or o.sm_bus_owner_flg <> n.sm_bus_owner_flg
        or o.sm_bus_owner_cert_no <> n.sm_bus_owner_cert_no
        or o.sm_bus_owner_cert_type_cd <> n.sm_bus_owner_cert_type_cd
        or o.gender_cd <> n.gender_cd
        or o.name <> n.name
        or o.degree_cd <> n.degree_cd
        or o.blood_type_cd <> n.blood_type_cd
        or o.ctysd_contr_oper_acct_flg <> n.ctysd_contr_oper_acct_flg
        or o.farm_flg <> n.farm_flg
        or o.have_work_unit_flg <> n.have_work_unit_flg
        or o.post_cd <> n.post_cd
        or o.title_cd <> n.title_cd
        or o.resdnt_char_cd <> n.resdnt_char_cd
        or o.rg_cd <> n.rg_cd
        or o.emply_flg <> n.emply_flg
        or o.dist_cd <> n.dist_cd
        or o.resdnt_flg <> n.resdnt_flg
        or o.nati_place <> n.nati_place
        or o.age <> n.age
        or o.owner_type_cd <> n.owner_type_cd
        or o.politic_status_cd <> n.politic_status_cd
        or o.ghb_rela_peop_flg <> n.ghb_rela_peop_flg
        or o.health_status_cd <> n.health_status_cd
        or o.spoken <> n.spoken
        or o.sys_in_cust_flg <> n.sys_in_cust_flg
        or o.cust_lev_cd <> n.cust_lev_cd
        or o.tax_stament_flg <> n.tax_stament_flg
        or o.indv_party_type_cd <> n.indv_party_type_cd
        or o.hxb_post_type_cd <> n.hxb_post_type_cd
        or o.grad_school <> n.grad_school
        or o.crdt_cust_flg <> n.crdt_cust_flg
        or o.main_type_cd <> n.main_type_cd
        or o.tax_num_null_rs_descb <> n.tax_num_null_rs_descb
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.pty_indv_eifsf1_cl(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状态代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 员工标志
    ,dist_cd -- 行政区域代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 取得税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 主体类型代码
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.pty_indv_eifsf1_op(
            party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,indv_en_name -- 个人英文名称
    ,birth_dt -- 出生日期
    ,birth_addr -- 出生地址
    ,depositr_cate_cd -- 存款人类别代码
    ,party_name -- 当事人名称
    ,indv_bus_flg -- 个体工商户标志
    ,indv_bus_cert_no -- 个体工商户证件号码
    ,nation_cd -- 国籍代码
    ,marriage_situ_cd -- 婚姻状况代码
    ,nati_place_cd -- 籍贯代码
    ,resd_status_cd -- 居住状态代码
    ,nationty_cd -- 民族代码
    ,taxpayer_idtfy_num -- 纳税人识别号
    ,real_name_flg -- 实名标志
    ,tax_resdnt_cty_cd -- 税收居民国家代码
    ,tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,sm_bus_owner_flg -- 小微企业主标志
    ,sm_bus_owner_cert_no -- 小微企业主证件号码
    ,sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,gender_cd -- 性别代码
    ,name -- 姓名
    ,degree_cd -- 学位代码
    ,blood_type_cd -- 血型代码
    ,ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,farm_flg -- 农户标志
    ,have_work_unit_flg -- 有工作单位标志
    ,post_cd -- 职务代码
    ,title_cd -- 职称代码
    ,resdnt_char_cd -- 居民性质代码
    ,rg_cd -- 地区代码
    ,emply_flg -- 员工标志
    ,dist_cd -- 行政区域代码
    ,resdnt_flg -- 居民标志
    ,nati_place -- 籍贯
    ,age -- 年龄
    ,owner_type_cd -- 业主类型代码
    ,politic_status_cd -- 政治面貌代码
    ,ghb_rela_peop_flg -- 本行关系人标志
    ,health_status_cd -- 健康状况代码
    ,spoken -- 口语
    ,sys_in_cust_flg -- 系统内客户标志
    ,cust_lev_cd -- 客户级别代码
    ,tax_stament_flg -- 取得税收居民取得自证声明标志
    ,indv_party_type_cd -- 个人当事人类型代码
    ,hxb_post_type_cd -- 在我行职务类型代码
    ,grad_school -- 毕业院校
    ,crdt_cust_flg -- 授信客户标志
    ,main_type_cd -- 主体类型代码
    ,tax_num_null_rs_descb -- 纳税人识别号空值原因描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.party_id -- 当事人编号
    ,o.lp_id -- 法人编号
    ,o.indv_en_name -- 个人英文名称
    ,o.birth_dt -- 出生日期
    ,o.birth_addr -- 出生地址
    ,o.depositr_cate_cd -- 存款人类别代码
    ,o.party_name -- 当事人名称
    ,o.indv_bus_flg -- 个体工商户标志
    ,o.indv_bus_cert_no -- 个体工商户证件号码
    ,o.nation_cd -- 国籍代码
    ,o.marriage_situ_cd -- 婚姻状况代码
    ,o.nati_place_cd -- 籍贯代码
    ,o.resd_status_cd -- 居住状态代码
    ,o.nationty_cd -- 民族代码
    ,o.taxpayer_idtfy_num -- 纳税人识别号
    ,o.real_name_flg -- 实名标志
    ,o.tax_resdnt_cty_cd -- 税收居民国家代码
    ,o.tax_resdnt_idti_type_cd -- 税收居民身份类型代码
    ,o.sm_bus_owner_flg -- 小微企业主标志
    ,o.sm_bus_owner_cert_no -- 小微企业主证件号码
    ,o.sm_bus_owner_cert_type_cd -- 小微企业主证件类型代码
    ,o.gender_cd -- 性别代码
    ,o.name -- 姓名
    ,o.degree_cd -- 学位代码
    ,o.blood_type_cd -- 血型代码
    ,o.ctysd_contr_oper_acct_flg -- 农村承包经营户标志
    ,o.farm_flg -- 农户标志
    ,o.have_work_unit_flg -- 有工作单位标志
    ,o.post_cd -- 职务代码
    ,o.title_cd -- 职称代码
    ,o.resdnt_char_cd -- 居民性质代码
    ,o.rg_cd -- 地区代码
    ,o.emply_flg -- 员工标志
    ,o.dist_cd -- 行政区域代码
    ,o.resdnt_flg -- 居民标志
    ,o.nati_place -- 籍贯
    ,o.age -- 年龄
    ,o.owner_type_cd -- 业主类型代码
    ,o.politic_status_cd -- 政治面貌代码
    ,o.ghb_rela_peop_flg -- 本行关系人标志
    ,o.health_status_cd -- 健康状况代码
    ,o.spoken -- 口语
    ,o.sys_in_cust_flg -- 系统内客户标志
    ,o.cust_lev_cd -- 客户级别代码
    ,o.tax_stament_flg -- 取得税收居民取得自证声明标志
    ,o.indv_party_type_cd -- 个人当事人类型代码
    ,o.hxb_post_type_cd -- 在我行职务类型代码
    ,o.grad_school -- 毕业院校
    ,o.crdt_cust_flg -- 授信客户标志
    ,o.main_type_cd -- 主体类型代码
    ,o.tax_num_null_rs_descb -- 纳税人识别号空值原因描述
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_indv_eifsf1_bk o
    left join ${iml_schema}.pty_indv_eifsf1_op n
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.pty_indv_eifsf1_cl d
        on
            o.party_id = d.party_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iml_schema}.pty_indv;
alter table ${iml_schema}.pty_indv truncate partition for ('eifsf1') reuse storage;

-- 4.2 exchange partition
alter table ${iml_schema}.pty_indv exchange subpartition p_eifsf1_19000101 with table ${iml_schema}.pty_indv_eifsf1_cl;
alter table ${iml_schema}.pty_indv exchange subpartition p_eifsf1_20991231 with table ${iml_schema}.pty_indv_eifsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_indv to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_indv_eifsf1_tm purge;
drop table ${iml_schema}.pty_indv_eifsf1_op purge;
drop table ${iml_schema}.pty_indv_eifsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.pty_indv_eifsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_indv', partname => 'p_eifsf1_20991231', granularity => 'SUBPARTITION', degree => 8, cascade => true);
