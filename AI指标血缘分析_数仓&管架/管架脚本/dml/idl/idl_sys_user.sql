set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

MERGE INTO SYS_USER A
USING MTL_PTY_EMPLY B
ON (A.REMARK = B.EMPLY_ID)
WHEN MATCHED THEN
UPDATE SET  
     A.DEPT_ID = COALESCE(TRIM(B.BELONG_DEPT_ID),TRIM(B.TELLER_BELONG_ORG_ID))
    /*
    case when substr(COALESCE(TRIM(B.BELONG_DEPT_ID),TRIM(B.TELLER_BELONG_ORG_ID)),1,3) = '800' then '000000' 
       else substr(COALESCE(TRIM(B.BELONG_DEPT_ID),TRIM(B.TELLER_BELONG_ORG_ID)),1,3) 
    end 
    */
   ,A.NICK_NAME   = B.LAST_NAME||FIRST_NAME
   ,A.EMAIL       = B.E_MAIL
   ,A.PHONENUMBER = B.MOBILE_PHONE_NUM
   ,A.SEX         = DECODE(B.GENDER_CD,'1','0','2','1','0','2','9','2'） -- 用户性别（0-男 1-女 2-未知）[上游:0-未知的性别,1-男性,2-女性,9-未说明的性别]
   ,A.DEL_FLAG    = DECODE(B.ID_MARK,'D','2','0')                        -- 删除标志（0-存在 2-删除）[上游:I-新增,D-删除]
   ,A.STATUS      = DECODE(B.EMPLY_STATUS_CD,'2','1','0')                -- 帐号状态（0-正常 1-停用）[上游:1-在职,2-离职]
   ,A.UPDATE_TIME = B.ETL_TIMESTAMP
   ,A.IS_UAP_USER = DECODE(B.EMPLY_STATUS_CD,'2','0',A.IS_UAP_USER) --离职账号收回统一门户登录MCS权限 20230222修改
   ,A.IS_OA       = DECODE(B.EMPLY_STATUS_CD,'2','0',A.IS_OA)       --离职账号收回移动OA登录MCS权限   20230222修改
   ,A.ACCT_INSTIT_ID      =(case
                     when substr(trim(B.BELONG_DEPT_ID), 1, 3) in ('800', '897', '898') then '000000'
                     when substr(trim(B.BELONG_DEPT_ID), 1, 3) in ('999', '000') then '000000'
                     when substr(trim(B.BELONG_DEPT_ID), 4, 1) in ('7', '8', '9')  then substr(trim(B.BELONG_DEPT_ID), 1, 3)
                     when length(substr(trim(B.BELONG_DEPT_ID), 1, 6)) = 6 and substr(trim(B.BELONG_DEPT_ID), 6, 1) = '0' then substr(trim(B.BELONG_DEPT_ID), 1, 5) || '1'
                     when length(substr(trim(B.BELONG_DEPT_ID), 1, 6)) = 6 and substr(trim(B.BELONG_DEPT_ID), 4, 3) = '001' then substr(trim(B.BELONG_DEPT_ID), 1, 3)
                     else substr(trim(B.BELONG_DEPT_ID), 1, 6)
                   end)
	,A.JXKH_ORG_ID=(case when substr(trim(B.BELONG_DEPT_ID), 1, 3) in ('800','897','898','999','000') then '000000' else trim(B.BELONG_DEPT_ID) end)
WHERE B.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
WHEN NOT MATCHED THEN 
  INSERT 
(                                 
    USER_ID
   ,DEPT_ID
   ,USER_NAME 
   ,NICK_NAME
   ,USER_TYPE
   ,EMAIL 
   ,PHONENUMBER
   ,SEX
   ,AVATAR 
   ,PASSWORD
   ,STATUS
   ,DEL_FLAG 
   ,LOGIN_IP
   ,LOGIN_DATE
   ,CREATE_BY 
   ,CREATE_TIME
   ,UPDATE_BY
   ,UPDATE_TIME
   ,REMARK
   ,IS_UAP_USER
   ,ACCT_INSTIT_ID
   ,JXKH_ORG_ID
)
VALUES
(
     seq_sys_user.NEXTVAL
    ,COALESCE(TRIM(B.BELONG_DEPT_ID),TRIM(B.TELLER_BELONG_ORG_ID))
    ,B.REGION_ACCT_NUM      
    ,B.LAST_NAME||FIRST_NAME
    ,'00'                 
    ,B.E_MAIL               
    ,B.MOBILE_PHONE_NUM     
    ,DECODE(B.GENDER_CD,'1','0','2','1','0','2','9','2'）  
    ,''
    ,'$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2'
    ,DECODE(B.EMPLY_STATUS_CD,'2','1','0')
    ,DECODE(B.ID_MARK,'D',2,0) 
    ,''
    ,''
    ,''
    ,B.UPDATE_DT
    ,''
    ,B.ETL_TIMESTAMP
    ,B.EMPLY_ID
    ,'0'
    ,case
      when substr(trim(B.BELONG_DEPT_ID), 1, 3) in ('800', '897', '898') then '000000'
      when substr(trim(B.BELONG_DEPT_ID), 1, 3) in ('999', '000') then '000000'
      when substr(trim(B.BELONG_DEPT_ID), 4, 1) in ('7', '8', '9')  then substr(trim(B.BELONG_DEPT_ID), 1, 3)
      when length(substr(trim(B.BELONG_DEPT_ID), 1, 6)) = 6 and substr(trim(B.BELONG_DEPT_ID), 6, 1) = '0' then substr(trim(B.BELONG_DEPT_ID), 1, 5) || '1'
      when length(substr(trim(B.BELONG_DEPT_ID), 1, 6)) = 6 and substr(trim(B.BELONG_DEPT_ID), 4, 3) = '001' then substr(trim(B.BELONG_DEPT_ID), 1, 3)
      else substr(trim(B.BELONG_DEPT_ID), 1, 6)
     end
	 ,case when substr(trim(B.BELONG_DEPT_ID), 1, 3) in ('800','897','898','999','000') then '000000' else trim(B.BELONG_DEPT_ID) end
)
WHERE B.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
;
COMMIT ;

-- 3.1 gather table status
--exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mtl_fdl_idx_index_data', degree => 8, cascade => true);