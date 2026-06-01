/* --2.0
Purpose:    共性加工层-个人客户基本信息
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20231231 icl_cmm_indv_cust_basic_info
CreateDate: 20190808
Logs:       20200110 翟若平 新增[通讯地址、通讯邮政编码、常住地址、常住邮政编码、户口所在地]字段、修改[家庭地址]字段的字段长度varchar2(100)->varchar2(300)
						20200424 周沁晖	新增[雇佣类型代码]
						20200605 周沁晖 调整T1表的过滤条件
														调整当事人证件类型相关信息的取数逻辑【tmp_cmm_indv_cust_basic_info_01】
														增加字段【税收居民国家代码、纳税人识别号、纳税人识别号空值原因描述、存款人类别代码、客户类型代码、销户日期、销户机构编号、销户柜员编号、拥有汽车标志、受薪人士标志、公务员标志、税收居民英文名称、其他职业信息、现单位入职日期】
														调整字段【学位代码、居民标志、农户标志】的取数逻辑
						20200724 陈伟峰 PTY_INDV修改算法sn->st，修改计数字段
						20200828 陈伟峰 调整eifs和crss优先取值逻辑
						20200925 陈伟峰 优化rg_cd字段取值 '' >'999999'
						20201019 陈伟峰 切换ecif数据来源 ecif1.0->ecif2.0
						20201229 谢  宁 修改日期20201028>${batch_date},实名标志t1.real_name_flg > decode(trim(t1.real_name_flg),'-','0',t1.real_name_flg),居民标志
						20210406 陈伟峰 elec_mail_addr电子邮件地址，1.0源取"个人网页"->"电子邮箱"
						20210524 何桐金 增加【关联交易标志】字段
						20210526 何桐金【职称等级代码】,【职务代码】ecif逻辑更改    --modify by 20210526xn 杨林林确认基本信息表更为准确
						               【出生日期】,【开户日期】,crss组【地区代码】逻辑更改
					  20210604 何桐金【民族代码】【	居住状况代码】逻辑调整，M层将空值分别转换为了97和13，故C层逻辑NVL的函数不再适用，改为用CASE WHEN
					  20210622 陈伟峰 调整【职业代码】取值，映射一位->直取，优化nvl取值逻辑   
					  20210702 陈伟峰 调整客户经理取值逻辑，'03' ->'dw003'
					  20210719 何桐金 新增字段【电话号码是否本人标志】
					                 调整【客户英文名称】逻辑
					  20210812 何桐金 更改【居住状况代码】逻辑：优先取对公信贷，取不到时取ecif. 对公信贷空转为了9，所以=9时要取ecif。
					  20210901 何桐金 调整ecif【境内外标志】取数逻辑
					  20211111 陈伟峰 调整【农户标志】取数逻辑，当信贷为'-'时，取EIFS的数据
					  20211111 陈伟峰 调整【单位所属行业类型代码】取数逻辑，当信贷为'-'时，取EIFS的数据
					  20220127 陈伟峰 调整【农户标志】加工逻辑，只取EIFS（业务沟通确认结果）
					  20220309 陈伟峰 调整【单位所属行业类型代码】加工逻辑，仅取EIFS
					  20220328 谢  宁 新增字段【创建渠道代码】 
					  20220609 温旺清 1、调整字段中文名称【关联交易标志-》关联方标志】
                            2、置空字段【当地房产标志-LOCAL_ESTATE_FLG、当地社保标志-LOCAL_SOCI_SECU_FLG、我行股东标志-HXB_SHARD_FLG、在我行办理过中间业务标志-HXB_TRAST_INTER_BUS_FLG、我行代发工资户标志-HXB_PAYOFF_SAL_ACCT_FLG、我行定期客户标志-HXB_REG_CUST_FLG、我行理财客户标志-HXB_FINC_CUST_FLG、我行VIP客户标识-HXB_VIP_CUST_IDF、配偶及子女移民标志-SPOUSE_AND_CHILD_IMG_FLG、享受国家优惠政策标志-ENJOY_CTY_PREFR_POLICY_FLG、雇佣类型代码-EMPLOY_TYPE_CD、公务员标志-CIV_SERT_FLG】
                            3、调整第一组字段【开户渠道代码、房产价值代码、业主类型代码、供养人口类型代码、子女人数代码、拥有汽车标志、受薪人士标志】的加工口径
                            4、调整第二组的取数数据源，由原对公信贷系统调整为综合信贷系统
									          5、新增字段【证件生效日期】
					  20220615 温旺清 1、调整第二组字段【授信客户标志】的加工口径
					  20220708 温旺清 1、调整表pty_party_phys_addr_h的物理地址代码映射			
					                  2、调整第一组的临时表t18 【pty_party_elec_addr_h】t18.elec_addr_type_cd'005001' -> t18.elec_addr_type_cd='01'
			      20220810 温旺清 1、调整【行政区域代码】的取数逻辑
			      20220811 曹永茂 调整第二组【地区代码】默认值为‘000000’	
            20220831 黄俊杰 调整第二组【婚姻状况代码】 case when t1.marriage_situ_cd = '90' then ' ' else t1.marriage_situ_cd end -> t1.marriage_situ_cd		  
				    20220908 温旺清 调整【创建渠道代码】的默认值加工逻辑
				    20220915 温旺清 取消第二组综合信贷系统数据来源，只从EIFS系统取
				    20220919 温旺清 1、置空字段【房产价值代码、供养人口、子女人数代码、拥有汽车标志、受薪人士标志】
				                    2、修改【行政区域代码】加工口径
				    20220929 曹永茂 1、调整tmp_cmm_indv_cust_basic_info_06的取数判断条件：电话类型代码码值落标调整  
				    20221009 温旺清 1、调整【标志】等字段对未知值'-'的转换
            20220905 陈伟峰 新增字段【反洗钱归属机构编号、自营客户标志代码、信贷客户标志代码、担保客户标志代码】    
            20221102 曹永茂 1、调整【联系电话】取数逻辑，有t31.mobile_phone->t31.cont_num   
            20221122 温旺清 修改字段名称【自营客户类型代码SEL_SUP_CUST_FLG_CD】->【存款类客户标志DEP_CLASS_CUST_FLG】、【信贷客户类型代码CRDT_CUST_FLG_CD】->【贷款类客户标志LOAN_CLASS_CUST_FLG】、【担保客户类型代码GUAR_CUST_FLG_CD】->【担保类客户标志GUAR_CLASS_CUST_FLG】，调整字段【存款类客户标志、担保类客户标志、贷款类客户标志】加工逻辑
            20221227 翟若平 调整字段【地区代码】的加工口径
            20230628 徐子豪 调整字段【我行代发工资户标志】的加工口径
            20231009 陈伟峰 调整字段【地区代码】的加工口径,增加默认值000000判断
            20231026 陈伟峰 调整字段【地区代码】的加工口径,回退原来口径，新调整：当区县为空或者为000000时取市，当市为空时取区县=000000，否则取公共表和证件信息表
                            以上新口径非必要不调整。
            20231212 陈伟峰 优化部分临时表加工逻辑tmp_cmm_indv_cust_basic_info_03、tmp_cmm_indv_cust_basic_info_04、tmp_cmm_indv_cust_basic_info_07、tmp_cmm_indv_cust_basic_info_08
            20240202 陈伟峰 添加客户号cust_id空值检查
            20250407 陈伟峰 调整销户日期、销户机构、销户柜员字段加工逻辑
			20260402 谭钧泽 调整临时表创建规则

*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition  and add partition
whenever sqlerror continue none;
--alter table ${icl_schema}.cmm_indv_cust_basic_info drop partition p_${retain_day};
alter table ${icl_schema}.cmm_indv_cust_basic_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 1.2 create table for exchage  and add partition
whenever sqlerror continue none ;
drop table ${icl_schema}.cmm_indv_cust_basic_info_ex purge;
drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_01 purge;
drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_02 purge;
drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_03 purge;
drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_04 purge;
drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_06 purge;
drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_07 purge;
drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_08 purge;
whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.tmp_cmm_indv_cust_basic_info_01
nologging
compress ${option_switch} for query high
as
select  party_id
       ,lp_id
       ,sorc_sys_cd
       ,cert_type_cd
       ,cert_num
       ,cert_addr
       ,issue_cert_org
       ,issue_cert_org_cty_cd
       ,cert_effect_dt
       ,cert_invalid_dt
       ,licen_issue_autho_dist_cd
       ,crdt_cd_cert_id
       ,cert_valid_flg
       ,cert_status_cd
       ,main_cert_no_flg
       ,start_dt
       ,end_dt
       ,id_mark
       ,src_table_name
       ,job_cd
       ,etl_timestamp
       ,rn 
  from
(select party_id
       ,lp_id
       ,sorc_sys_cd
       ,cert_type_cd
       ,cert_num
       ,cert_addr
       ,issue_cert_org
       ,issue_cert_org_cty_cd
       ,cert_effect_dt
       ,cert_invalid_dt
       ,licen_issue_autho_dist_cd
       ,crdt_cd_cert_id
       ,cert_valid_flg
       ,cert_status_cd
       ,main_cert_no_flg
       ,start_dt
       ,end_dt
       ,id_mark
       ,src_table_name
       ,job_cd
       ,etl_timestamp,
				row_number() over(partition by s1.party_id order by nvl(trim(s1.main_cert_no_flg), '0') desc,s1.cert_effect_dt desc) as rn
	 from ${iml_schema}.pty_party_cert_info_h s1
	where s1.start_dt <= to_date('${batch_date}','yyyymmdd')
	  and s1.end_dt > to_date('${batch_date}','yyyymmdd')
	  and s1.job_cd = 'eifsf1')
  where rn = 1
;
commit;

create table ${icl_schema}.tmp_cmm_indv_cust_basic_info_02
nologging
compress ${option_switch} for query high
as select * from (select
                    s1.party_id
                    ,s1.title_cd
                    ,s1.post_cd
                    ,s1.work_unit_name
                    ,s1.work_unit_addr
                    ,s1.tel_num
                    ,s1.zip_cd
                    ,s1.work_unit_char_cd
                    ,s1.corp_bl_induty_type_cd
                    ,s1.now_corp_work_years
                    ,s1.career_cd
                    ,s1.empyt_dt
--                    ,row_number() over(partition by s1.party_id order by s1.start_dt desc) as rid
                from ${iml_schema}.pty_party_work_info_h s1
                where s1.start_dt <= to_date('${batch_date}','yyyymmdd')
                 and s1.end_dt > to_date('${batch_date}','yyyymmdd')
                 and s1.job_cd = 'eifsf1'
                 ) t
    where 1=1
;
commit;

create table ${icl_schema}.tmp_cmm_indv_cust_basic_info_03
nologging
compress ${option_switch} for query high
as select * from (select party_id
                        ,elec_addr_type_cd
                        ,elec_addr
                        ,src_sys_cd
                        ,job_cd
                        ,seq_num
                        ,row_number () over (partition by party_id,elec_addr_type_cd,src_sys_cd,job_cd order by seq_num desc ) as rn
                    from ${iml_schema}.pty_party_elec_addr_h
                   where start_dt <= to_date('${batch_date}','yyyymmdd')
                     and end_dt > to_date('${batch_date}','yyyymmdd')
                     and job_cd = 'eifsf1')
                   where rn=1;

commit;

create table ${icl_schema}.tmp_cmm_indv_cust_basic_info_04
nologging
compress ${option_switch} for query high
as select * from (select party_id
                        ,phys_addr_type_cd
                        ,cont_addr
                        ,zip_cd
                        ,tel_num
                        ,fax_num
                        ,phys_addr
                        ,dist_cd
                        ,addr_status_type_cd
                        ,src_sys_cd
                        ,job_cd
                        ,seq_num
                        ,city_cd
                        ,row_number () over (partition by party_id,phys_addr_type_cd,src_sys_cd,job_cd order by seq_num desc ) as rn
                   from ${iml_schema}.pty_party_phys_addr_h
                  where start_dt <= to_date('${batch_date}','yyyymmdd')
                    and end_dt > to_date('${batch_date}','yyyymmdd')
                    and job_cd = 'eifsf1')
                  where rn=1;

commit;

create table ${icl_schema}.tmp_cmm_indv_cust_basic_info_06
nologging
compress ${option_switch} for query high
as
select
    c.party_id
   ,max(case when c.tel_type_cd = '07' then c.tel_num else ' ' end) as significant_phone
   ,max(case when c.tel_type_cd = '05' then c.tel_num else ' ' end) as mobile_phone
   ,max(case when c.tel_type_cd = '02' then c.tel_num else ' ' end) as home_phone
   ,max(case when c.tel_type_cd = '01' then c.tel_num else ' ' end) as cont_num  --联系电话   
   ,max(case when c.tel_char_cd = '1' then c.tel_num else ' ' end) as author_phone --本人号码
from ${iml_schema}.pty_tel_info_h c
where (c.tel_type_cd in ('01' ,'05','02','07') or c.tel_char_cd = '1')
  and c.job_cd = 'eifsf1'
  and c.start_dt <= to_date('${batch_date}','yyyymmdd')
  and c.end_dt > to_date('${batch_date}','yyyymmdd')
group by c.party_id
;


create table ${icl_schema}.tmp_cmm_indv_cust_basic_info_07 as 
select
    party_id
   ,max(case when fin_ind_cd = '0101' then ind_val else 0 end) as indv_mon_inco  --个人月收入
   ,max(case when fin_ind_cd = '0106' then ind_val else 0 end) as indv_anl_inco  --个人年收入
   ,max(case when fin_ind_cd = '0103' then ind_val else 0 end) as family_mon_inco --家庭月收入
   ,max(case when fin_ind_cd = '0111' then ind_val else 0 end) as family_anl_inco  --家庭年收入   
from ${iml_schema}.pty_party_fin_ind_h 
where fin_ind_cd in ('0101','0106','0103','0111')
  and job_cd = 'eifsf1'
  and start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')
group by party_id
;

create table ${icl_schema}.tmp_cmm_indv_cust_basic_info_08 as 
select
    party_id
   ,max(case when attr_name = 'P0010' then attr_val else ' ' end) as ghb_shard_flg  --本行股东标志
   ,max(case when attr_name = 'B0002' then attr_val else ' ' end) as dom_overs_flg  --境内外标志
   ,max(case when attr_name = 'P0014' then attr_val else ' ' end) as hxb_payoff_sal_acct_flg   --我行代发工资户标志
from ${iml_schema}.pty_party_attr_h 
where attr_name in ('P0010','B0002','P0014')
  and job_cd = 'eifsf1'
  and start_dt <= to_date('${batch_date}','yyyymmdd')
  and end_dt > to_date('${batch_date}','yyyymmdd')
group by party_id
;


whenever sqlerror exit sql.sqlcode;
-- 2.1 insert data to ex table
create table ${icl_schema}.cmm_indv_cust_basic_info_ex
nologging
compress ${option_switch} for query high
as select * from ${icl_schema}.cmm_indv_cust_basic_info where 0=1;


-- 第一组（共一组）ecif个人客户信息

whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${icl_schema}.cmm_indv_cust_basic_info_ex(
    etl_dt                                  --数据日期
    ,lp_id                                  --法人编号
    ,cust_id                                --客户编号
    ,cust_type_cd                           --客户类型代码
    ,cert_type_cd                           --证件类型代码
    ,cert_no                                --证件号码
	  ,cert_effect_dt                         --证件生效日期
    ,cert_exp_dt                            --证件到期日期
    ,cert_issue_org                         --证件签发机关
    ,cust_name                              --客户名称
    ,cust_en_name                           --客户英文名称
    ,open_acct_dt                           --开户日期
    ,belong_org_id                          --所属机构编号
	  ,anti_mon_lau_belong_org_id             --反洗钱归属机构编号
    ,open_acct_teller_id                    --开户柜员编号
    ,gender_cd                              --性别代码
    ,open_acct_chn_cd                       --开户渠道代码
    ,create_chn_cd                          --创建渠道代码
    ,birth_dt                               --出生日期
    ,marriage_situ_cd                       --婚姻状况代码
    ,resd_status_cd                         --居住状况代码
    ,estate_val_cd                          --房产价值代码
    ,owner_type_cd                          --业主类型代码
    ,politic_status_cd                      --政治面貌代码
    ,nation_cd                              --国籍代码
    ,dist_cd                                --行政区域代码
    ,rg_cd                                  --地区代码
    ,nationty_cd                            --民族代码
    ,nati_place                             --籍贯
    ,cust_status_cd                         --客户状态代码
    ,depositr_cate_cd                       --存款人类别代码
    ,prov_pulation_type_cd                  --供养人口
    ,child_number_cd                        --子女人数代码
    ,cont_num                               --电话号码
    ,cont_num_is_self_flg                   --电话号码是否本人标志	
    ,open_acct_rsrv_mobile_no               --开户预留手机号码
    ,elec_mail_addr                         --电子邮件地址
    ,cust_lev_cd                            --客户级别代码
    ,edu_cd                                 --学历代码
    ,degree_cd                              --学位代码
    ,grad_sch                               --毕业学校
    ,title_cd                               --职称等级代码
    ,post_cd                                --职务代码
    ,career_cd                              --职业代码
    ,posta_addr                             --通讯地址
    ,comm_zip_cd                            --通讯邮政编码
    ,resdnt_addr                            --常住地址
    ,resdnt_zip_cd                          --常住邮政编码
    ,rpr_site                               --户口所在地
    ,family_addr                            --家庭地址
    ,family_zip_cd                          --家庭邮政编码
    ,nome_phone_num                         --家庭电话号码
    ,work_unit_name                         --工作单位名称
    ,work_unit_addr                         --工作单位地址
    ,work_unit_tel                          --工作单位电话
    ,work_unit_zip_cd                       --工作单位邮政编码
    ,work_unit_char_cd                      --登记注册类型代码
    ,corp_bl_induty_type_cd                 --单位所属行业类型代码
    ,corp_work_years                        --单位工作年限
    ,indv_mon_inco                          --个人月收入
    ,indv_anl_inco                          --个人年收入
    ,family_mon_inco                        --家庭月收入
    ,family_anl_inco                        --家庭年收入
    ,tax_resdnt_idti_cd                     --税收居民身份代码
    ,tax_red_cty_cd                         --税收居民国家代码
    ,tax_num                                --纳税人识别号
    ,tax_num_null_rs_descb                  --纳税人识别号空值原因描述
    ,stament_flg                            --自证声明标志
    ,indv_bus_flg                           --个体工商户标志
    ,sm_bus_owner_flg                       --小微企业主标志
    ,resdnt_flg                             --居民标志
    ,farm_flg                               --农户标志
    ,ghb_emply_flg                          --本行员工标志
    ,ghb_shard_flg                          --本行股东标志
    ,crdt_cust_flg                          --授信客户标志
    ,real_name_flg                          --实名标志
    ,dom_overs_flg                          --境内外标志
    ,local_estate_flg                       --当地房产标志
    ,local_soci_secu_flg                    --当地社保标志
    ,ctysd_contr_oper_acct_flg              --农村承包经营户标志
    ,ghb_rela_peop_flg                      --本行关系人标志
    ,hxb_shard_flg                          --我行股东标志
    ,hxb_trast_inter_bus_flg                --在我行办理过中间业务标志
    ,hxb_payoff_sal_acct_flg                --我行代发工资户标志
    ,hxb_reg_cust_flg                       --我行定期客户标志
    ,hxb_finc_cust_flg                      --我行理财客户标志
    ,hxb_vip_cust_idf                       --我行vip客户标识
    ,spouse_and_child_img_flg               --配偶及子女移民标志
    ,enjoy_cty_prefr_policy_flg             --享受国家优惠政策标志
    ,cust_mgr_id                            --客户经理编号
    ,employ_type_cd						             	--雇佣类型代码
    ,dep_class_cust_flg                     --存款类客户标志
    ,loan_class_cust_flg                    --贷款类客户标志
    ,guar_class_cust_flg                    --担保类客户标志
    ,clos_acct_dt       					          --销户日期
    ,clos_acct_org_id   					          --销户机构编号
    ,clos_acct_teller_id					          --销户柜员编号
    ,have_car_flg       					          --拥有汽车标志
    ,salar_flg          					          --受薪人士标志
    ,civ_sert_flg       					          --公务员标志
    ,tax_red_en_name    					          --税收居民英文名称
    ,other_career_info  					          --其他职业信息
    ,curt_corp_empyt_dt 					          --现单位入职日期
    ,rela_tran_flg                          --关联方标志
    ,job_cd                                 --任务代码
    ,etl_timestamp
)
select
    to_date('${batch_date}','yyyymmdd')                  --数据日期
    ,t1.lp_id                                            --法人编号
    ,t1.party_id                                         --客户编号
    ,t1.indv_party_type_cd                               --客户类型代码
    ,t4.cert_type_cd                                     --证件类型代码
    ,t4.cert_num                                         --证件号码
	  ,t4.cert_effect_dt                                   --证件生效日期
    ,t4.cert_invalid_dt                                  --证件到期日期
    ,t4.issue_cert_org                                   --证件签发机关
    ,t1.party_name                                       --客户名称
    ,nvl(t1.legal_en_name,t98.party_name)                --客户英文名称
    ,t2.effect_dt                                        --开户日期
    ,t3.open_acct_org_id                                 --所属机构编号
	  ,t35.cust_belong_org                                 --反洗钱归属机构编号
    ,t3.open_acct_user_id                                --开户柜员编号
    ,t1.gender_cd                                        --性别代码
    ,t35.init_system_id                                  --开户渠道代码
    ,nvl(trim(t35.init_system_id),'-')                   --创建渠道代码
    ,t1.birth_dt                                         --出生日期
    ,t1.marriage_situ_cd                                 --婚姻状况代码
    ,t1.resd_status_cd                                   --居住状况代码
    ,''                                                  --房产价值代码  
    ,case when t1.indv_bus_flg = '1' then '1' 
	        when t1.sm_bus_owner_flg = '1' then '2' 
		else '' end                                          --业主类型代码
    ,t1.politic_status_cd                                --政治面貌代码
    ,t1.nation_cd                                        --国籍代码
    ,t4.licen_issue_autho_dist_cd                        --行政区域代码
--    ,coalesce(t13.dist_cd, t1.dist_cd, t1.rg_cd) as rg_cd --地区代码
    ,case when trim(t13.dist_cd) is not null and t13.dist_cd <>'000000' then t13.dist_cd
          when trim(t13.city_cd) is not null   then t13.city_cd
          when trim(t13.city_cd) is  null and t13.dist_cd ='000000' then t13.dist_cd 
          when trim(t1.dist_cd) is not null  then t1.dist_cd
          else t1.rg_cd end                              --地区代码
    ,t1.nationty_cd                                      --民族代码
    ,t1.nati_place                                       --籍贯
    ,t7.party_status_cd                                  --客户状态代码
    ,t1.depositr_cate_cd                                 --存款人类别代码
    ,''                                                  --供养人口
    ,''                                                  --子女人数代码
    ,t31.cont_num                                        --电话号码
    ,case when t31.author_phone <>' ' then '1' else '0' end          --电话号码是否本人标志	
    ,t31.significant_phone                               --开户预留手机号码
    ,t18.elec_addr                                       --电子邮件地址  --1.0取个人网页，2.0取电子邮箱，已确认口径，差异接受
    ,t1.cust_lev_cd                                      --客户级别代码
    ,t25.edu_cd                                          --学历代码
    ,t25.degree_cd                                       --学位代码
    ,t1.grad_school                                      --毕业学校
    ,nvl(t1.title_cd,'9')                                --职称等级代码    --modify by 20210526xn  杨林林确认基本信息表更为准确
    ,nvl(t1.post_cd,'9')                                 --职务代码    --modify by 20210526xn  杨林林确认基本信息表更为准确
    ,t1.career_cd                                        --职业代码
    ,t6.cont_addr                                        --通讯地址
    ,t6.zip_cd                                           --通讯邮政编码
    ,t13.cont_addr                                       --常住地址
    ,t13.zip_cd                                          --常住邮政编码
    ,t14.cont_addr                                       --户口所在地
    ,t15.cont_addr                                       --家庭地址
    ,t15.zip_cd                                          --家庭邮政编码
    ,t31.home_phone                                      --家庭电话号码
    ,t27.work_unit_name                                  --工作单位名称
    ,t27.work_unit_addr                                  --工作单位地址
    ,t27.tel_num                                         --工作单位电话
    ,t27.zip_cd                                          --工作单位邮政编码
    ,nvl(t27.work_unit_char_cd,'900')                    --登记注册类型代码
    ,nvl(t27.corp_bl_induty_type_cd,'-')                 --单位所属行业类型代码
    ,t27.now_corp_work_years                             --单位工作年限
    ,t42.indv_mon_inco                                   --个人月收入
    ,t42.indv_anl_inco                                   --个人年收入
    ,t42.family_mon_inco                                 --家庭月收入
    ,t42.family_anl_inco                                 --家庭年收入
    ,t1.tax_resdnt_idti_type_cd                          --税收居民身份代码
    ,t1.tax_resdnt_cty_cd                                --税收居民国家代码
    ,t1.taxpayer_idtfy_num                               --纳税人识别号
    ,t1.tax_num_null_rs_descb                            --纳税人识别号空值原因描述
    ,t1.tax_stament_flg                                  --自证声明标志
    ,nvl(trim(t1.indv_bus_flg), '0')                     --个体工商户标志
    ,nvl(trim(t1.sm_bus_owner_flg), '0')                 --小微企业主标志
    ,t1.resdnt_flg                                       --居民标志
    ,t1.farm_flg                                         --农户标志
    ,t1.emply_flg                                        --本行员工标志
    ,t43.ghb_shard_flg                                   --本行股东标志
    ,t1.crdt_cust_flg                                    --授信客户标志
    ,trim(t1.real_name_flg)                              --实名标志
    -- ,t1.main_type_cd                                  --境内外标志
    ,t43.dom_overs_flg                                        --境内外标志
    ,''                                                  --当地房产标志
    ,''                                                  --当地社保标志
    ,trim(t1.ctysd_contr_oper_acct_flg)                  --农村承包经营户标志
    ,nvl(trim(t1.ghb_rela_peop_flg), '0')                --本行关系人标志
    ,''                                                  --我行股东标志
    ,''                                                  --在我行办理过中间业务标志
    ,t43.hxb_payoff_sal_acct_flg                         --我行代发工资户标志
    ,''                                                  --我行定期客户标志
    ,''                                                  --我行理财客户标志
    ,''                                                  --我行vip客户标识
    ,''                                                  --配偶及子女移民标志
    ,''                                                  --享受国家优惠政策标志
    ,t12.rela_party_id                                   --客户经理编号
    ,''	                                                 --雇佣类型代码
    ,tb.aml_dep_flag                                     --存款类客户标志
    ,tb.aml_loan_flag                                    --贷款类客户标志
    ,tb.aml_guar_flag                                    --担保类客户标志
    ,case when t7.party_status_cd = '1' then null else to_date(trim(t35.close_dt),'yyyymmdd') end	--销户日期
    ,case when t7.party_status_cd = '1' then '' else t35.last_updated_org end					  --销户机构编号
    ,case when t7.party_status_cd = '1' then '' else t35.last_updated_te end		        --销户柜员编号
    ,''									                                                                --拥有汽车标志
    ,''                                                     						                --受薪人士标志
    ,''													                                                        --公务员标志
    ,t1.legal_en_name                                    --税收居民英文名称
    ,t1.other_career_name                                --其他职业信息
    ,t27.empyt_dt                                        --现单位入职日期
    ,null as rela_tran_flg                               --关联方标志
    ,t1.job_cd                                           --任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')    --etl处理时间戳
from ${iml_schema}.pty_indv t1  --个人当事人
left join ${iol_schema}.eifs_t00_per_cust_no_ref ta
  on ta.cust_num = t1.party_id
 and ta.start_dt <= to_date('${batch_date}','yyyymmdd')
 and ta.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iol_schema}.eifs_t01_per_cust_info tb
  on ta.party_id=tb.party_id
 and tb.start_dt <= to_date('${batch_date}','yyyymmdd')
 and tb.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iml_schema}.pty_party t2  --当事人
  on t1.party_id=t2.party_id
 and t2.create_dt <=to_date('${batch_date}','yyyymmdd')
 and t2.job_cd ='eifsf1'
 and t2.id_mark <> 'D'
 and t2.party_type_cd  in('201003' ,'201004') --个人客户 和个人担保客户
left join ${iml_schema}.pty_cust t3  --客户
 on t1.party_id=t3.party_id
 and t3.create_dt <=to_date('${batch_date}','yyyymmdd')
 and t3.job_cd ='eifsf1'
 and t3.id_mark <> 'D'
left join ${icl_schema}.tmp_cmm_indv_cust_basic_info_01 t4 --当事人证件信息历史临时表
  on t1.party_id = t4.party_id
left join ${icl_schema}.tmp_cmm_indv_cust_basic_info_04 t6 --当事人物理地址历史
  on t1.party_id=t6.party_id
 and t6.phys_addr_type_cd='03'   --通讯地址
 and t6.src_sys_cd = 'EIFS'
 and t6.job_cd = 'eifsf1'
left join ${icl_schema}.tmp_cmm_indv_cust_basic_info_04 t13 --当事人物理地址历史
  on t1.party_id=t13.party_id
 and t13.phys_addr_type_cd='01'   --居住地址
 and t13.src_sys_cd = 'EIFS'
 and t13.job_cd = 'eifsf1'
left join ${icl_schema}.tmp_cmm_indv_cust_basic_info_04 t14 --当事人物理地址历史
  on t1.party_id=t14.party_id
 and t14.phys_addr_type_cd='02'   --户籍地址
 and t14.src_sys_cd = 'EIFS'
 and t14.job_cd = 'eifsf1'
left join ${icl_schema}.tmp_cmm_indv_cust_basic_info_04 t15 --当事人物理地址历史
  on t1.party_id=t15.party_id
 and t15.phys_addr_type_cd='07'   --家庭地址
 and t15.src_sys_cd = 'EIFS'
 and t15.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_status_h t7 --当事人状态历史
  on t1.party_id = t7.party_id
 and t7.sorc_sys_cd = 'EIFS'
 and t7.party_status_type_cd = 'CD1271'  --对私对公客户公共信息
 and t7.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t7.end_dt > to_date('${batch_date}','yyyymmdd')
 and t7.job_cd = 'eifsf1'
left join ${icl_schema}.tmp_cmm_indv_cust_basic_info_03 t18 --当事人电子地址历史
  on t1.party_id=t18.party_id
 and t18.elec_addr_type_cd='01'   --电子邮箱
 and t18.src_sys_cd = 'EIFS'
 and t18.job_cd = 'eifsf1'
left join ${iml_schema}.pty_party_acdmic_record_h t25
  on t25.party_id = t1.party_id
 and t25.job_cd = 'eifsf1'
 and t25.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t25.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${icl_schema}.tmp_cmm_indv_cust_basic_info_07 t42    --财务指标临时表
  on t1.party_id = t42.party_id
left join ${iml_schema}.pty_party_rela_h t12 --当事人关系历史
  on t1.party_id = t12.party_id
 and t12.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t12.end_dt > to_date('${batch_date}','yyyymmdd')
 and t12.job_cd = 'eifsf1'
 and t12.party_rela_type_cd='dw003'
left join ${icl_schema}.tmp_cmm_indv_cust_basic_info_02 t27
  on t1.party_id = t27.party_id
left join ${icl_schema}.tmp_cmm_indv_cust_basic_info_06 t31
  on t1.party_id = t31.party_id
left join ${iol_schema}.eifs_t00_party_pub_info t35
  on t1.party_id=t35.cust_num
 and t35.cust_type_cd = '1'
 and t35.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t35.end_dt > to_date('${batch_date}','yyyymmdd')
left join ${iml_schema}.pty_party_name_h t98
  on t1.party_id = t98.party_id
 and t98.party_name_type_cd = '06'
 and t98.start_dt <= to_date('${batch_date}','yyyymmdd')
 and t98.end_dt > to_date('${batch_date}','yyyymmdd')
 and t98.job_cd = 'eifsf1'
left join ${icl_schema}.tmp_cmm_indv_cust_basic_info_08 t43    --标签指标临时表
  on t1.party_id = t43.party_id
where t1.indv_party_type_cd in ('1','5') --个人客户,对私担保客户
  and t1.start_dt <= to_date('${batch_date}','yyyymmdd')
  and t1.end_dt > to_date('${batch_date}','yyyymmdd')
  and t1.job_cd = 'eifsf1'
;
commit;



-- 2.2 exchage ex table  and target table
alter table ${icl_schema}.cmm_indv_cust_basic_info exchange partition p_${batch_date} with table ${icl_schema}.cmm_indv_cust_basic_info_ex;


-- 2.3 客户号空值检查
whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${icl_schema}.cmm_indv_cust_basic_info 
  	                                where trim(cust_id) is null
  	                                  and etl_dt = to_date('${batch_date}', 'yyyymmdd'));
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'invalid data:cust_id exists null ');
    end if;
  end loop;
end;
/



-- 3.1 drop ex table
drop table ${icl_schema}.cmm_indv_cust_basic_info_ex purge;
--drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_01 purge;
--drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_02 purge;
--drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_03 purge;
--drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_04 purge;
--drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_06 purge;
--drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_07 purge;
--drop table ${icl_schema}.tmp_cmm_indv_cust_basic_info_08 purge;

-- 3.2 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${icl_schema}',tabname => 'cmm_indv_cust_basic_info',partname => 'p_${batch_date}',ESTIMATE_PERCENT => 10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade => true,force=>true,degree => 8);
